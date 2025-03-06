clc
clear

%Plot Font
L = 1.5;
F = 14;

X_norm = 0.1;
Y_norm = 0.04;

%figure('units','normalized','outerposition',[0 0 0.3 0.55])
for i = 1 %:3


    %title_node = append('Steady-State-',num2str(power(j)),'W-',num2str(pressure(i)),'mTorr.csv')
    title_node = append('Steady-State-125W-1000mTorr.csv')

    raw_data = csvread(title_node,1,1);
    plot_zr = raw_data(:,[1 2]);

    data_meta = raw_data(:,11);
    
    % Making mesh for contour plot
    N = 200;        
    xv1 = linspace(0, 0.0975, N);
    yv1 = linspace(0.2, 0.23, N);
    [X1,Y1] = meshgrid(xv1, yv1);
    xv2 = linspace(0, 0.08141, N);
    yv2 = linspace(0.23, 0.2395, N);
    [X2,Y2] = meshgrid(xv2, yv2);
    
    % Graphing contour data
    Z1 = griddata(plot_zr(:,1), plot_zr(:,2), data_meta, X1, Y1);
    Z2 = griddata(plot_zr(:,1), plot_zr(:,2), data_meta, X2, Y2);
    
    Y1_corrected = abs(Y1-0.24);
    Y2_corrected = abs(Y2-0.24);

    figure('units','normalized','outerposition',[0 0 0.3 0.5])
    surf(X1/X_norm,Y1_corrected/Y_norm,Z1,'EdgeColor','none')
    hold on
    surf(X2/X_norm,Y2_corrected/Y_norm,Z2,'EdgeColor','none')
    view([0,90]);
    grid off
    hold off
    %ylabel('Distance from Applicator: m')
    %xlabel('Radial Distance: m')
    ylabel({'Distance from Applicator:';'Normalize'})
    xlabel('Radial Distance: Normalize')
    c = colorcube(64);
    colormap('jet');
    set(gca, 'YDir','reverse')
    cb = colorbar('eastoutside');
    %caxis([-inf 8e19])
    ylabel(cb,'751.465nm Line Intensity: [A.U.]','FontSize',F+2)
    set(gca,'FontSize',F)

end
hold off

%figure
%[X,Y,Z] = cylinder(I_total);
%surf(X,Y,Z)
%view([0,90]);
%grid off
%power_title = append('P_{MW Heating} = ',num2str(powers(j)),'W');
%title(power_title,'FontWeight','Normal')
%ylabel('Distance from Applicator: m')
%xlabel('Radial Distance: m')
%c = colorcube(64);
%colormap('jet');
%set(gca, 'YDir','reverse')
%cb = colorbar('northoutside');
