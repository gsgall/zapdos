clc
clear

clc
clear

%Plot Font
L = 1.5;
F = 14;


power = [25 40 55 70 85 100 125];
pressure = [1000];
light_range = 22;
light_number = [696.543
	        706.722
	        714.704
	        727.294
	        738.398
	        750.387
	        751.465
	        763.511
	        772.376
	        772.421
	        794.818
	        800.616
	        801.479
	        810.369
	        811.531
	        826.452
	        840.821
	        842.465
	        852.144
	        866.794
	        912.297
	        922.450];

light_waves = ["WL_696dot543"
	        "WL_706dot722"
	        "WL_714dot704"
	        "WL_727dot294"
	        "WL_738dot398"
	        "WL_750dot387"
	        "WL_751dot465"
	        "WL_763dot511"
	        "WL_772dot376"
	        "WL_772dot421"
	        "WL_794dot818"
	        "WL_800dot616"
	        "WL_801dot479"
	        "WL_810dot369"
	        "WL_811dot531"
	        "WL_826dot452"
	        "WL_840dot821"
	        "WL_842dot465"
	        "WL_852dot144"
	        "WL_866dot794"
	        "WL_912dot297"
	        "WL_922dot450"];

light_wave_data = zeros(17977,light_range);
color = ["r" "g" "b" "c" "m" "#A2142F" "k"];

for i = 1:1
    for j = 7:-1:1

        title_node = append('Steady-State-',num2str(power(j)),'W-',num2str(pressure(i)),'mTorr.csv')
    
        raw_data = csvread(title_node,1,1);
        plot_zr = raw_data(:,[1 2]);

        for k = 1:light_range
            %light_wave_data(:,k) = ( light_number(k) * 1e-9 / (6.626e-34 * 3e8)) * raw_data(:,90+k);
            light_wave_data(:,k) = raw_data(:,3+k);
        end

        light_total = sum(light_wave_data,"all");

        for k = 1:light_range
            %light_wave_norm(:,k) = light_wave_data(:,k) / light_total;
            light_wave_norm(:,k) = light_wave_data(:,k)*0.00313;
        end

        light_wave_norm_sum = sum(light_wave_norm);
        %figure('units','normalized','outerposition',[0 0 0.3 0.5])
        %plot(light_number(1:light_range),light_wave_norm_sum)
        c = jet(7);
        bar(light_number(1:light_range),light_wave_norm_sum,20,'FaceColor',color(j))
        hold on

    end
end

file_name = strings(1,41);

% Removing Multiple Emission Data at same power
%Power Increasing
file_name(1) = "11-03-14-430";  %25 #Go
file_name(2) = "11-06-06-533";  %30
file_name(3) = "11-08-38-539";  %35
file_name(4) = "11-10-03-380";  %40 #Go
file_name(5) = "11-13-28-815";  %45
file_name(6) = "11-16-22-986";  %50
file_name(7) = "11-18-22-014";  %55 #Go
file_name(8) = "11-21-07-570";  %60
file_name(9) = "11-23-41-315";  %65
file_name(10) = "11-25-49-117"; %70 #Go
file_name(11) = "11-27-40-634"; %75
file_name(12) = "11-29-44-562"; %80
file_name(13) = "11-32-04-085"; %85 #Go
file_name(14) = "11-34-32-050"; %90
file_name(15) = "11-38-02-339"; %95
file_name(16) = "11-40-33-566"; %100 #Go
file_name(17) = "11-42-28-285"; %105
file_name(18) = "11-44-40-239"; %110
file_name(19) = "11-46-31-683"; %115
file_name(20) = "11-48-12-875"; %120
file_name(21) = "11-49-56-196"; %125 #Go
%Power Decreasing
file_name(22) = "11-52-51-558"; %125
file_name(23) = "11-54-03-554"; %115
file_name(24) = "11-55-20-475"; %110
file_name(25) = "11-56-35-328"; %105
file_name(26) = "11-57-44-201"; %100
file_name(27) = "11-59-51-937"; %95
file_name(28) = "12-00-56-949"; %90
file_name(29) = "12-01-56-816"; %85
file_name(30) = "12-03-42-721"; %80
file_name(31) = "12-04-50-941"; %75
file_name(32) = "12-06-01-400"; %70
file_name(33) = "12-07-37-319"; %65
file_name(34) = "12-09-09-178"; %60
file_name(35) = "12-10-19-223"; %55
file_name(36) = "12-11-29-305"; %50
file_name(37) = "12-12-49-969"; %45
file_name(38) = "12-13-59-968"; %40
file_name(39) = "12-15-06-463"; %35
file_name(40) = "12-16-17-081"; %30
file_name(41) = "12-17-30-242"; %25


        % Emission Data Normalized: Two Plots
        c = jet(7);
        
        light_data = zeros(1,7);
        number = [1,4,7,10,13,16,21];
        color = ["r" "g" "b" "c" "m" "#A2142F" "k"];
        %figure
        for i = 1:7
            time_int = xlsread("Microwave-Light-Hystersis.xlsx","USB4H103001_"+file_name(number(i)),"D8");
            light_data = xlsread("Microwave-Light-Hystersis.xlsx","USB4H103001_"+file_name(number(i)),"A16:B3663");
        
            plot(light_data(:,1),light_data(:,2)/time_int,'Color',color(i))
            hold on
        
            done = i/7
        end
        hold off
        xlim([690 900])
        ylim([0 inf])
        xlabel("Wavelength [nm]")
        ylabel("Intensity [A.U.]")
        title("Increasing Delivered Power")
        set(gca,'FontSize',14)
        legend("125","100","85","70",...
               "55","40","25",...
               Location="northeast")
        
%         light_data = zeros(1,21);
%         figure
%         for i = 41:-1:21
%             time_int = xlsread("Microwave-Light-Hystersis.xlsx","USB4H103001_"+file_name(i),"D8");
%             light_data = xlsread("Microwave-Light-Hystersis.xlsx","USB4H103001_"+file_name(i),"A16:B3663");
%         
%             plot(light_data(:,1),light_data(:,2)/time_int,'Color',c(42-i,:))
%             hold on
%         
%             done = (63-i)/42
%         end
%         hold off
%         %xlim([500 900])
%         ylim([0 inf])
%         xlabel("Wavelength [nm]")
%         ylabel("Intensity [A.U.]")
%         title("Decreasing Delivered Power")
%         set(gca,'FontSize',14)
%         legend("25","30","35","40","45","50","55","60","65","70","75",...
%                "80","85","90","95","100","105","110","115","120","125",...
%                Location="west")
