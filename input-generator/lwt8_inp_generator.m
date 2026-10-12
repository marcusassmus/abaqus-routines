%% Skript zur Generierung von input-Dateien f¸r lwt8.for
% Geeignet zur Generierung von regelm‰ﬂigen Rechteck-Netzen 
% mit mind. 3 Elementen in x_1 und x_2-Richtung
clear
clc
%% Definition der Abmaﬂe der Platte und der Elemente sowie des Dateinamens
% Input: Abmaﬂe der Platte L_1 und L_2; Elementkantenl‰ngen el1 und el2
% Output: Anzahl der Elemente in x_1 und x_2-Richtung
%for L2 = [ 1620 1540 1460 1380 1300 1220 1140 1040 970 890 810 730 650 570 490 400 320 240 ]
for anz2 = [ 4 8 16 32 64 ]
    % Abmaﬂ L_1 in x_1-Richtung:
    L1 = 1620;
    % % Abmaﬂ L_2 in x_2-Richtung:
    L2 = 810;
    % Anzahl der Elemente in x_1-Richtung:
    anz1 = 2*anz2;
    % Anzahl der Elemente in x_2-Richtung:
    %anz2 = 5;
    % Elementkantenl‰nge in x_1-Richtung:
    EL1 = L1/anz1;
    % Elementkantenl‰nge in x_2-Richtung:
    EL2 = L2/anz2;
    % Fehlermeldung, falls Abmaﬂe L_1 und L_2 kein ganzzahliges Vielfaches
    % der Elementkantenl‰ngen sind:
    if mod(L1,EL1) ~= 0
        'Fehler! Das Abmaﬂ der Platte in x_1-Richtung ist kein ganzzahliges Vielfaches der Elementkantenl‰nge in x_1-Richtung!'
        return
    end
    if mod(L2,EL2) ~= 0
        'Fehler! Das Abmaﬂ der Platte in x_2-Richtung ist kein ganzzahliges Vielfaches der Elementkantenl‰nge in x_2-Richtung!'
        return
    end
    % Name der input-Datei:
    filename=strcat('benchmark_uel_',num2str(anz1),'x',num2str(anz2),'.inp');
    %% Berechnung der Koordinaten der Knoten:
    % nodes enth‰lt in der ersten Spalte die Knotennummer und in den folgenden
    % 3 Spalten die x, y, z Koordinaten
    % Der Vektor rechts enth‰lt alle Knoten mit x_1=L_1.
    % Der Vektor links enth‰lt alle Knoten mit x_1=0.
    % Der Vektor oben enth‰lt alle Knoten mit x_2=L_2.
    % Der Vektor unten enth‰lt alle Knoten mit x_2=0.
    [nodes,rechts,links,oben,unten] ...
        = lwt8_inp_generator_nodes_coor(anz1,anz2,EL1,EL2,L1,L2);
    %% Ermittlung der Elementtypologie:
    % elements enth‰lt in der ersten Spalte die Elementnummer und in den
    % folgenden 8 Spalten die zugehˆrigen Knoten.
    elements = lwt8_inp_generator_elements(anz1,anz2,EL1,EL2,L1,nodes);
    % elements_visual enth‰lt die Elementtopologie f¸r die
    % Visualisierung, beginnend bei 100001:
    elements_visual = elements;
    elements_visual(:,1) = 100000+elements_visual(:,1);
    %% Input-Datei erstellen:
    % Textfragmente aus Dateien lesen:
    part1 = fileread('inp_preamble.txt');
    part1b = fileread('inp_preamble2.txt');
    part2 = fileread('inp_middle.txt');
    part3 = fileread('inp_middle2.txt');
    part4 = fileread('inp_middle3.txt');
    part5 = fileread('inp_end.txt');
    % Textfragmente und Matlab-Felder werden im Wechsel in die inp-Datei
    % geschrieben:
    fileID = fopen(filename,'w');
    fprintf(fileID,part1);
    fclose(fileID);
    %
    fileID = fopen(filename,'a');
    fprintf(fileID,' XMIN = 0\n XMAX = %7.1f\n YMIN = 0\n YMAX = %7.1f\n',L1,L2);
    fclose(fileID);
    % 
    fileID = fopen(filename,'a');
    fprintf(fileID,part1b);
    fclose(fileID);
    % 
    dlmwrite(filename,nodes,'-append','delimiter',',','precision','%10i%12.5f%12.5f%12.5f')
    %
    fileID = fopen(filename,'a');
    fprintf(fileID,part2);
    fclose(fileID);
    %
    dlmwrite(filename,elements,'-append','delimiter',',','precision','%5i')
    %
    fileID = fopen(filename,'a');
    fprintf(fileID,part3);
    fclose(fileID);
    %
    dlmwrite(filename,elements_visual,'-append','delimiter',',','precision','%5i')
    %
    fileID = fopen(filename,'a');
    fprintf(fileID,part4);
    fprintf(fileID,'*Nset, nset=Set-2\n');
    fclose(fileID);
    %
    dlmwrite(filename,rechts,'-append','delimiter',',','precision','%5i,')
    %
    fileID = fopen(filename,'a');
    fprintf(fileID,'*Nset, nset=Set-3\n');
    fclose(fileID);
    %
    dlmwrite(filename,links,'-append','delimiter',',','precision','%5i,')
    %
    fileID = fopen(filename,'a');
    fprintf(fileID,'*Nset, nset=Set-4\n');
    fclose(fileID);
    %
    dlmwrite(filename,oben,'-append','delimiter',',','precision','%5i,')
    %
    fileID = fopen(filename,'a');
    fprintf(fileID,'*Nset, nset=Set-5\n');
    fclose(fileID);
    %
    dlmwrite(filename,unten,'-append','delimiter',',','precision','%5i,')
    %
    fileID = fopen(filename,'a');
    fprintf(fileID,part5);
    fclose(fileID);
end















