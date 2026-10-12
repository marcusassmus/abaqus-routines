function elements = lwt8_inp_generator_elements(anz1,anz2,EL1,EL2,L1,nodes)
    %% Berechnung der Elementtopologie:
    % Anzahl der Elemente:
    el_anz = anz1*anz2;
    % Feld der Elemente; 1. Spalte Elementnummer, 2.-9. Spalte: Knotennr
    elements = zeros(el_anz,9);
    for i=1:length(elements)
        elements(i,1) = i;
    end
    % Definiere die Eckknoten für jedes Element:
    for i=1:anz1
        for j=1:anz2
            % Elementnummer:
            elnum = j+(i-1)*anz2;
            elements(elnum,2) = elnum+i-1;
            elements(elnum,3) = elnum+i;
            elements(elnum,4) = elements(elnum,2)+2+anz2;
            elements(elnum,5) = elements(elnum,4)-1;
        end
    end
    % Zur Definition der Mittenknoten werden für jedes Element die Koordinaten
    % des Elementmittelpunkts berechnet:
    elmitte = zeros(el_anz,3);
    elmitte(:,1) = elements(:,1);
    for i=1:anz1
        for j=1:anz2
            % Elementnummer:
            elnum = j+(i-1)*anz2;
            % x-Koordinate:
            elmitte(elnum,2) = L1-(i-0.5)*EL1;
            % y-Koordinate:
            elmitte(elnum,3) = (j-0.5)*EL2;
        end
    end
    for el = 1:length(elements)
        % Definition des rechten mittleren Knotens für jedes Element:
        xkoor = elmitte(el,2)+EL1/2;
        ykoor = elmitte(el,3);
        for k = 1:length(nodes)
           if (nodes(k,2) == xkoor) && (nodes(k,3) == ykoor)
               elements(el,6) = nodes(k,1);
           end
        end
        % Definition des oberen mittleren Knotens für jedes Element:
        xkoor = elmitte(el,2);
        ykoor = elmitte(el,3)+EL2/2;
        for k = 1:length(nodes)
           if (nodes(k,2) == xkoor) && (nodes(k,3) == ykoor)
               elements(el,7) = nodes(k,1);
           end
        end
        % Definition des linken mittleren Knotens für jedes Element:
        xkoor = elmitte(el,2)-EL1/2;
        ykoor = elmitte(el,3);
        for k = 1:length(nodes)
           if (nodes(k,2) == xkoor) && (nodes(k,3) == ykoor)
               elements(el,8) = nodes(k,1);
           end
        end
        % Definition des unteren mittleren Knotens für jedes Element:
        xkoor = elmitte(el,2);
        ykoor = elmitte(el,3)-EL2/2;
        for k = 1:length(nodes)
           if (nodes(k,2) == xkoor) && (nodes(k,3) == ykoor)
               elements(el,9) = nodes(k,1);
           end
        end
    end
end