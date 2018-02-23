
close all

figure
hold on
load('base_dep')
load('dep_thks')


density = 6.37; %g/cc

massft = (dep(:,4)./1000)*density * 238/308 * (3/100);
plot(dep(:,1),massft,'Color','b', 'LineWidth',2)

massft = (base_dep(:,4)./1000)*density * 238/308 * (3/100);
plot(base_dep(:,1),massft,'Color',[1 0.5 0],'LineWidth', 2)


plot([0,6], [75, 75], 'r--');
legend('With Deposit', 'Without Deposit', 'CI Threshold')
title('Deposit Mass/Foot along Pipe', 'FontSize',14)
xlabel('Travel Distance (m)', 'FontSize',14)
ylabel('Mass per Foot (g/ft)', 'FontSize',14)

grid on








