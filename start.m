% Main
%% Parameter
clc, clear all, close all
Length     = 100;  % network length
Width      = 100;  %    "    width
% sinkX    = Length / 2;
% sinkY    = Width / 2;
sinkX      = 50;
sinkY      = 50;
initEnergy  = 0.5;
transEnergy = 50*0.000000001;
recEnergy   = 50*0.000000001;
fsEnergy    = 10*0.000000000001;
mpEnergy    = 0.0013*0.000000000001;
aggrEnergy  = 5*0.000000001;
round       = 99999;
packetLength    = 6400;
ctrPacketLength = 200;
numNodes = 100;  % number of nodes
p        = 0.05; % ratio of number of CH (default)
d0       = 87;   % distance threshold
T1       = 100;  % canopy.m threshold
T2       = 87;   %     "        "

% (Length, Width, sinkX, sinkY, initEnergy, transEnergy, recEnergy, fsEnergy, mpEnergy, aggrEnergy)
netArch       = newNetwork(Length, Width, sinkX, sinkY...
                           , initEnergy, transEnergy, recEnergy, fsEnergy, mpEnergy, aggrEnergy);
roundArch     = newRound(round, packetLength, ctrPacketLength);
init_nodeArch = newNodes(netArch, numNodes);
nodeArch      = init_nodeArch;     % node's arch for LEACH
proposed_nodeArch = init_nodeArch; % node's arch for Proposed



% %% Proposed method
% %%%%%%% Initialize %%%%%%%
% for i= 1:proposed_nodeArch.numNode
%     proposed_nodeArch.node(i).CID = -1;
% end
% 
% 
% %%%%%%% Layer Phase %%%%%%%
% notLayerZero = 1; % no of nodes that are not in Layer 0.
% d_th = d0;
% % Temp : all nodes \ {nodes in Layer 0}
% % Layer marking using threshold d_th for each layer
% for i = 1:proposed_nodeArch.numNode
%     dist = calDistance(proposed_nodeArch.node(i).x, proposed_nodeArch.node(i).y, netArch.Sink.x, netArch.Sink.y);
%     if( dist > d_th )
%         if( dist > 2*d_th )
%             proposed_nodeArch.node(i).Layer = 2;
%         else
%             proposed_nodeArch.node(i).Layer = 1;
%         end
%         Temp_xy(1, notLayerZero) = proposed_nodeArch.node(i).x;
%         Temp_xy(2, notLayerZero) = proposed_nodeArch.node(i).y;
%         Temp_index(1, notLayerZero) = i;
% %         Temp(inLayer0).x = proposed_nodeArch.node(i).x;
% %         Temp(inLayer0).y = proposed_nodeArch.node(i).y;
% %         Temp_index(1, inLayer0) = i;
%         notLayerZero = notLayerZero + 1;
%     else
%         proposed_nodeArch.node(i).Layer = 0;
%     end
% end
% 
% 
% %%%%%%% Clustering Phase %%%%%%%
% % Determine number of k using [Canopy algo].
% [ k, canopy_centr, canopy_centr_node ] = usingCanopy( Temp_xy, T1, T2 );
% % plot_canopy
% 
% % Determine number of k using [kOpt].
% % notLayer0 = count;
% % noOfk = round(notLayer0 * p);
% % fprintf('Proposed : number of k = %d.\n',noOfk);
% 
% % Clustering using [K-means algo].   
% noOfk = length(canopy_centr_node);
% [cluster, centr] = usingKmeans(Temp_xy, noOfk, canopy_centr_node);
% 
% % mark cluster id
% for i = 1:notLayerZero-1
%     proposed_nodeArch.node(Temp_index(1,i)).CID = cluster(i); % CID = which cluster belongs to
% end
% 
% % **FOR TEST** assign to it's parent
% for i = 1:proposed_nodeArch.numNode
%     if(proposed_nodeArch.node(i).CID == -1)
%         proposed_nodeArch.node(i).parent = netArch.Sink;
%     else
%         proposed_nodeArch.node(i).parent.x = centr(1,proposed_nodeArch.node(i).CID);
%         proposed_nodeArch.node(i).parent.y = centr(2,proposed_nodeArch.node(i).CID);
%     end
% end
% 
% plot_kmeans
% 
% 
% %%%%%%% CH & RN Selection Phase %%%%%%%
% MaxSCH = 0;
% MaxXRN = 0;











%% LEACH
par = struct;
for round = 1:roundArch.numRound
% for round = 1:500
    fprintf('[LEACH] round = %d.\n',round);
    clusterModel = newCluster(netArch, nodeArch, 'leach', round, p);
    clusterModel = dissEnergyCH(clusterModel, roundArch);
    clusterModel = dissEnergyNonCH(clusterModel, roundArch);
    nodeArch     = clusterModel.nodeArch; % new node architecture after select CHs
    
    par = plotResults(clusterModel, round, par);
    if nodeArch.numDead == nodeArch.numNode
        break
    end
end

% plot_leach


