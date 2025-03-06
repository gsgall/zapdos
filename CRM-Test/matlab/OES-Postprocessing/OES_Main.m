clc
clear

file_name = strings(1,41);

% Removing Multiple Emission Data at same power
file_name(1) = "11-03-14-430";
file_name(2) = "11-06-06-533";
file_name(3) = "11-08-38-539";
file_name(4) = "11-10-03-380";
file_name(5) = "11-13-28-815";
file_name(6) = "11-16-22-986";
file_name(7) = "11-18-22-014";
file_name(8) = "11-21-07-570";
file_name(9) = "11-23-41-315";
file_name(10) = "11-25-49-117";
file_name(11) = "11-27-40-634";
file_name(12) = "11-29-44-562";
file_name(13) = "11-32-04-085";
file_name(14) = "11-34-32-050";
file_name(15) = "11-38-02-339";
file_name(16) = "11-40-33-566";
file_name(17) = "11-42-28-285";
file_name(18) = "11-44-40-239";
file_name(19) = "11-46-31-683";
file_name(20) = "11-48-12-875";
file_name(21) = "11-49-56-196";
file_name(22) = "11-52-51-558";
file_name(23) = "11-54-03-554";
file_name(24) = "11-55-20-475";
file_name(25) = "11-56-35-328";
file_name(26) = "11-57-44-201";
file_name(27) = "11-59-51-937";
file_name(28) = "12-00-56-949";
file_name(29) = "12-01-56-816";
file_name(30) = "12-03-42-721";
file_name(31) = "12-04-50-941";
file_name(32) = "12-06-01-400";
file_name(33) = "12-07-37-319";
file_name(34) = "12-09-09-178";
file_name(35) = "12-10-19-223";
file_name(36) = "12-11-29-305";
file_name(37) = "12-12-49-969";
file_name(38) = "12-13-59-968";
file_name(39) = "12-15-06-463";
file_name(40) = "12-16-17-081";
file_name(41) = "12-17-30-242";

disp("0: Emission Data Normalized: 51 Plots")
disp("1: Emission Data Normalized: Two Plots")
disp("2: 808 Line Data Normalized")
disp("3: Excitation Temperature Plot")
n = input('Enter a number: ');

switch n
    case 0
        % Emission Data Normalized: 41 Plots
        x = 1:41;
        xq = 500:0.1:900;
        light_data = zeros(1,41);
        for i = 1:length(file_name)
            time_int = xlsread("Microwave-Light-Hystersis.xlsx","USB4H103001_"+file_name(i),"D8");
            light_data = xlsread("Microwave-Light-Hystersis.xlsx","USB4H103001_"+file_name(i),"A16:B3663");
            light_data(:,2) = light_data(:,2)/time_int;

            f = @(z) interp1(light_data(:,1),light_data(:,2),z,'pchip');
        
            figure
            plot(light_data(:,1),light_data(:,2),"b-")
            hold on
            plot(xq,f(xq),"r--")
            hold off
            title(file_name(i))
            xlim([500 900])
            set(gca,'FontSize',14)
        
            done = i/41
        end
    case 1
        % Emission Data Normalized: Two Plots
        c = jet(21);
        
        light_data = zeros(1,21);
        figure
        for i = 1:21
            time_int = xlsread("Microwave-Light-Hystersis.xlsx","USB4H103001_"+file_name(i),"D8");
            light_data = xlsread("Microwave-Light-Hystersis.xlsx","USB4H103001_"+file_name(i),"A16:B3663");
        
            plot(light_data(:,1),light_data(:,2)/time_int,'Color',c(i,:))
            hold on
        
            done = i/42
        end
        hold off
        %xlim([500 900])
        ylim([0 inf])
        xlabel("Wavelength [nm]")
        ylabel("Intensity [A.U.]")
        title("Increasing Delivered Power")
        set(gca,'FontSize',14)
        legend("25","30","35","40","45","50","55","60","65","70","75",...
               "80","85","90","95","100","105","110","115","120","125",...
               Location="west")
        
        light_data = zeros(1,21);
        figure
        for i = 41:-1:21
            time_int = xlsread("Microwave-Light-Hystersis.xlsx","USB4H103001_"+file_name(i),"D8");
            light_data = xlsread("Microwave-Light-Hystersis.xlsx","USB4H103001_"+file_name(i),"A16:B3663");
        
            plot(light_data(:,1),light_data(:,2)/time_int,'Color',c(42-i,:))
            hold on
        
            done = (63-i)/42
        end
        hold off
        %xlim([500 900])
        ylim([0 inf])
        xlabel("Wavelength [nm]")
        ylabel("Intensity [A.U.]")
        title("Decreasing Delivered Power")
        set(gca,'FontSize',14)
        legend("25","30","35","40","45","50","55","60","65","70","75",...
               "80","85","90","95","100","105","110","115","120","125",...
               Location="west")
    case 2
        % 808 Line Data Normalized
        x_up = 25:5:125;
        x_down = flip(x_up);
        line_808 = zeros(1,41);
        for i = 1:length(file_name)
            time_int = xlsread("Microwave-Light-Hystersis.xlsx","USB4H103001_"+file_name(i),"D8");
            line_808_data = xlsread("Microwave-Light-Hystersis.xlsx","USB4H103001_"+file_name(i),"B3093");
        
            line_808(i) = line_808_data / time_int;
        
            done = i/41
        end
        
        figure
        plot(x_up,line_808(1:21),"o-b")
        hold on
        plot(x_down,line_808(21:41),"o-r")
        hold off
        xlabel("Delivered Power [W]")
        ylabel("Intensity [A.U.]")
        title("Intensity of Measured 808.977 nm Line")
        legend("Increasing Power","Decreasing Power",Location="northwest")
        set(gca,'FontSize',14)
    otherwise
        NIST_data = xlsread("Peak-Reference-Data_Old.xlsx","Peaks-And-Data");
        wavelength = NIST_data(:,1);
        gA = NIST_data(:,3);
        Ek = NIST_data(:,4);
        Intens = zeros(length(wavelength),1);
        Te = zeros(length(file_name),1);
        
        for i = 1:length(file_name)
            time_int = xlsread("Microwave-Light-Hystersis.xlsx","USB4H103001_"+file_name(i),"D8");
            light_data = xlsread("Microwave-Light-Hystersis.xlsx","USB4H103001_"+file_name(i),"A16:B3663");
            light_data(:,2) = light_data(:,2)/time_int;
    
            for j = 1:length(wavelength)
            
                f = @(z) interp1(light_data(:,1),light_data(:,2),z,'pchip');
            
                Intens(j) = f(wavelength(j)-2.5541);
            end
            
            I_wave = Intens.*wavelength;
            yaxis = log(I_wave./gA);
            p = polyfit(Ek,yaxis,1);
            x = [min(Ek) max(Ek)];
            y = polyval(p,x);
    
            if i == 36
                figure
                scatter(Ek,yaxis)
                hold on
                plot(x,y)
                hold off
                ylabel('Log(I_j_i*\lambda_j_i)/(g_k*A_k_i)) [counts]');
                xlabel('E_k [eV]');
                set(gca,'FontSize',14)
            end
    
            current_Te = -1/p(1)
            Te(i) = current_Te;       
        end

        x_up = 25:5:125;
        x_down = flip(x_up);

        figure
        plot(x_up,Te(1:21),"o-b")
        hold on
        plot(x_down,Te(21:41),"o-r")
        hold off
        xlabel("Delivered Power [W]")
        ylabel("T_{exc} [eV]")
        title("Excitation Temperature Vs Power")
        legend("Increasing Power","Decreasing Power")
        set(gca,'FontSize',14)
end


