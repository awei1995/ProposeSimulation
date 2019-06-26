% Main
%% Parameter
clc, clear all, close all
numNodes   = 300;  % number of nodes
Length     = 300;  % network length
Width      = 300;  %    "    width
% sinkX    = Length / 2;
% sinkY    = Width / 2;
sinkX      = 150;
sinkY      = 150;
initEnergy  = 0.5;
transEnergy = 50*0.000000001;
recEnergy   = 50*0.000000001;
fsEnergy    = 10*0.000000000001;
mpEnergy    = 0.0013*0.000000000001;
aggrEnergy  = 5*0.000000001;
round       = 99999;
packetLength    = 6400;
ctrPacketLength = 200;
p        = 0.1; % ratio of number of CH (default)
d0       = 87;   % distance threshold
T1       = 100;  % canopy.m threshold
T2       = 87;   %     "        "

% (Length, Width, sinkX, sinkY, initEnergy, transEnergy, recEnergy, fsEnergy, mpEnergy, aggrEnergy)
netArch       = newNetwork(Length, Width, sinkX, sinkY...
                           , initEnergy, transEnergy, recEnergy, fsEnergy, mpEnergy, aggrEnergy);
roundArch     = newRound(round, packetLength, ctrPacketLength);
init_nodeArch = newNodes(netArch, numNodes);
nodeArch      = init_nodeArch;     % node's arch for LEACH
p_nodeArch = init_nodeArch; % node's arch for Proposed



%% Proposed method

%%%%%%% Layer Phase %%%%%%%
notLayerZero = 1; % no of nodes that are not in Layer 0.
d_th = d0;
% Temp : all nodes \ {nodes in Layer 0}
% Layer marking using threshold d_th for each layer
for i = 1:p_nodeArch.numNode
    dist = calDistance(p_nodeArch.node(i).x, p_nodeArch.node(i).y, netArch.Sink.x, netArch.Sink.y);
    if( dist > d_th )
        if( dist > 2*d_th )
            p_nodeArch.node(i).Layer = 2;
        else
            p_nodeArch.node(i).Layer = 1;
        end
        Temp_xy(1, notLayerZero) = p_nodeArch.node(i).x;
        Temp_xy(2, notLayerZero) = p_nodeArch.node(i).y;
        Temp_index(1, notLayerZero) = i;
%         Temp(inLayer0).x = proposed_nodeArch.node(i).x;
%         Temp(inLayer0).y = proposed_nodeArch.node(i).y;
%         Temp_index(1, inLayer0) = i;
        notLayerZero = notLayerZero + 1;
    else
        p_nodeArch.node(i).Layer = 0;
    end
end


%%%%%%% Reset (each round)%%%%%%%
for i= 1:p_nodeArch.numNode
    p_nodeArch.node(i).CID = -1;
    p_nodeArch.node(i).child = 0;
end
%%%%%%% Clustering Phase %%%%%%%
% Determine number of k using [Canopy algo].
[ k, canopy_centr, canopy_centr_node ] = usingCanopy( Temp_xy, T1, T2 );
% plot_canopy

% % Determine number of k using [kOpt].
% % notLayer0 = count;
% % noOfk = round(notLayer0 * p);
% % fprintf('Proposed : number of k = %d.\n',noOfk);

% Clustering using [K-means algo].   
noOfk = length(canopy_centr_node);
[cluster, centr] = usingKmeans(Temp_xy, noOfk, canopy_centr_node);

% mark cluster id
for i = 1:notLayerZero-1
    locNode = [p_nodeArch.node(i).x, p_nodeArch.node(i).y];
    [minToCentr, index] = min(sqrt(sum((repmat(locNode, noOfk, 1) - (centr'))' .^ 2)));
    
    p_nodeArch.node(Temp_index(1,i)).CID = cluster(i); % CID = which cluster belongs to
end


%%%%%%% CH & RN Selection Phase %%%%%%%
locAlive = find(~p_nodeArch.dead);
for i = 1:length(locAlive)
    locNode_alive(i,1) = p_nodeArch.node(locAlive(i)).x;
    locNode_alive(i,2) = p_nodeArch.node(locAlive(i)).y;
end
for i = 1:noOfk
    locNode_centr = [centr(1,i), centr(2,i)];
    [minToCentr, index] = min(sqrt(sum((repmat(locNode_centr, length(locAlive), 1) - locNode_alive)' .^ 2)));
    
    % becomes CH
    p_nodeArch.node(locAlive(index)).type = 'C';
    % temp
    centr_node(i) = p_nodeArch.node(locAlive(index));
    centr_node_index(i) = locAlive(index);
end

% assign parent
for i = 1:p_nodeArch.numNode
    % Layer 0 -> sink
    if (p_nodeArch.node(i).CID == -1)
        p_nodeArch.node(i).parent = netArch.Sink;
    % CH -> sink
    elseif ( p_nodeArch.node(i).type == 'C' )
        p_nodeArch.node(i).parent = netArch.Sink;
    % CM -> CH
    else
        for j =1:noOfk
            if(p_nodeArch.node(i).CID == centr_node(j).CID)
                p_nodeArch.node(centr_node_index(j)).child = p_nodeArch.node(centr_node_index(j)).child  + 1;
                p_nodeArch.node(i).parent.x = centr_node(j).x;
                p_nodeArch.node(i).parent.y = centr_node(j).y;
            end
        end
    end
end

plot_kmeans



MaxSCH = 0;
MaxSRN = 0;







% 
% 
% %% LEACH
% par = struct;
% for round = 1:999999%roundArch.numRound
% % for round = 1:500
%     fprintf('[LEACH] round = %d.\n',round);
%     clusterModel = newCluster(netArch, nodeArch, 'leach', round, p);
%     clusterModel = dissEnergyNonCH(clusterModel, roundArch);
%     clusterModel = dissEnergyCH(clusterModel, roundArch);
%     nodeArch     = clusterModel.nodeArch; % new node architecture after select CHs
%     
%     par = plotResults(clusterModel, round, par);
%     
%     fprintf('[LEACH] number of DEAD node = %d.\n',nodeArch.numDead);
%     
%     if nodeArch.numDead == nodeArch.numNode
%         break
%     end
% end
% 
% plot_leach


