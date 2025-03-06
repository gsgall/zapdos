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
color = ["r" "g" "b" "c" "m" "y" "k"];

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
            light_wave_norm(:,k) = light_wave_data(:,k);
        end

        light_wave_norm_sum = sum(light_wave_norm);
        %figure('units','normalized','outerposition',[0 0 0.3 0.5])
        %plot(light_number(1:light_range),light_wave_norm_sum)
        c = jet(7);
        bar(light_number(1:light_range),light_wave_norm_sum,20,color(j))
        hold on

    end
end
hold off