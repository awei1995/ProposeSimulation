function createfigure(X1, X2, X3, proposedEnergy, leachEnergy, hhcaEnergy, proposedAlive, leachAlive, hhcaAlive, ...
                        pFND, pHND, FND, HND, hFND, hHND, C1, C2, C3)
%CREATEFIGURE(X1,Y1,Y2,Y3)
%  X1:  vector of x data - round (proposed)
%  X2:  vector of x data - round (leach)
%  A1:  vector of y data - energy (proposed)
%  A2:  vector of y data - energy (leach)
%  B1:  vector of y data - dead (proposed)
%  B2:  vector of y data - dead (leach)
%  C1:  vector of y data - packetToBS (proposed)
%  C2:  vector of y data - packetToBS (leach)
color1 = '#118DF0'; color1 = sscanf(color1(2:end),'%2x%2x%2x',[1 3])/255; % blue
color2 = '#004182'; color2 = sscanf(color2(2:end),'%2x%2x%2x',[1 3])/255; % heavy blue
color3 = '#FBFFA3'; color3 = sscanf(color3(2:end),'%2x%2x%2x',[1 3])/255; % yellow
color4 = '#FF4B68'; color4 = sscanf(color4(2:end),'%2x%2x%2x',[1 3])/255; % red




%%%%%% Sum of energy of nodes vs. round
for k=1:1
    figure
    hold on
    Y1 = zeros(1,1200);
    Y2 = zeros(1,1200);
    Y3 = zeros(1,1200);
    Y1(1:X1) = proposedEnergy(1:X1);
    Y2(1:X2) = leachEnergy(1:X2);
    Y3(1:X3) = hhcaEnergy(1:X3);
    X = 1:100:1200;
    p = plot(X,Y1(X),'-x',...
             X,Y2(X),'--+',...
             X,Y3(X),'-o');
    p(1).LineWidth =1; p(1).MarkerSize=8; p(1).Color=[0 0 1];
    p(2).LineWidth =1; p(2).MarkerSize=8; p(2).Color=[0 0 0];
    p(3).LineWidth =1; p(3).MarkerSize=8; p(3).Color=[1 0 0];
    axis([0,1200,0,150]);
    set(gca,'XTick',[0:200:1200]);
    set(gca,'YTick',[0:30:150]);
    % Create x-label y-label
    xlabel('Round','FontWeight','bold','FontSize',15);
    ylabel('Total remaining energy','FontWeight','bold','FontSize',15);
    % % Create title
    % title('Total remaining energy','FontWeight','bold',...
    %     'FontSize',12,...
    %     'FontName','Cambria');
    grid on
    box on
end

%%%%%% Number of dead node vs. round
for k =1:1
    figure
    x = 1:3; 	
    y = [pFND pHND; hFND hHND; FND HND];
    b = bar(x, y, 1);  			
    color_background=[color1 color2 color3];
    for i = 1:length(x)
        text(x(i)-0.225,y(i,1)+40,num2str(y(i,1)));
        text(x(i)+0.075,y(i,2)+40,num2str(y(i,2)));
    end
    set(b(:,1),'FaceColor',color1);
    set(b(:,2),'FaceColor',color3);
    ylabel('Round');	
    set(gca, 'xticklabel', {'PROPOSED','HHCA','LEACH'});
end



%%%%%% Number of alive node vs. round
for k=1:1
    figure
    hold on;
    xr = (X1/100 +1)*100;
    Y1 = zeros(1,xr);
    Y2 = zeros(1,xr);
    Y3 = zeros(1,xr);
    Y1(1:X1) = proposedAlive(1:X1);
    Y2(1:X2) = leachAlive(1:X2);
    Y3(1:X3) = hhcaAlive(1:X3);
    
    X = 0:100:xr;
    Z = 1:100:xr;
    p = plot(X,Y1(Z),'-x',...
             X,Y2(Z),'--+',...
             X,Y3(Z),'-o');
    p(1).LineWidth =1; p(1).MarkerSize=8; p(1).Color=color1;
    p(2).LineWidth =1; p(2).MarkerSize=8; p(2).Color=color2;
    p(3).LineWidth =1; p(3).MarkerSize=8; p(3).Color=color4;
    axis([0,xr,0,300]);
    set(gca,'XTick',[0:200:xr]);
    set(gca,'YTick',[0:30:300]);
    % Create x-label y-label
    xlabel('Round','FontWeight','bold','FontSize',15);
    ylabel('Number of dead nodes','FontWeight','bold','FontSize',15);
    % % Create title
    % title('Number of dead node','FontWeight','bold',...
    %     'FontSize',12,...
    %     'FontName','Cambria');

    grid on
    box on
end




% %%%%%% Number of packet sent to BS vs. round
% figure
% % Create plot
% p = plot(X1,C1,X2,C2,X3,C3,'LineWidth',1);
% p(1).Color=[0 0 1]; p(2).Color=[0 0 0]; p(3).Color=[1 0 0];
% 
% % Create x-label y-label
% xlabel('Round','FontWeight','bold','FontSize',11,'FontName','Cambria');
% ylabel('# of packets sent to BS nodes','FontWeight','bold','FontSize',11,'FontName','Cambria');
% 
% % Create title
% title('Number of packet sent to BS','FontWeight','bold',...
%     'FontSize',12,...
%     'FontName','Cambria');
% 
% grid on
% box on






