function [nodes,rechts,links,oben,unten] = lwt8_inp_generator_nodes_coor(anz1,anz2,EL1,EL2,L1,L2)
    %% Berechnung der Koordinaten der Eckknoten:
    % Anzahl der Knoten:
    node_anz = (2*anz1+1)*(anz2+1)+(anz1+1)*anz2;
    % Feld der Knoten; 1. Spalte Knotennummer, 2. Spalte x-Koordinate, 
    % 3. Spalte y-Koordinate, 4. Spalte z-Koordinate
    nodes = zeros(node_anz,4);
    for i=1:length(nodes)
        nodes(i,1) = i;
    end
    % Anzahl der Eckknoten:
    eck_anz = (anz1+1)*(anz2+1);
    % Berechnung der Koordinaten der Eckknoten:
    k=0;
    for i=1:anz1+1
        k=k+1;
        for j=1:anz2+1
            numnode = j+(k-1)*(anz2+1);
            nodes(numnode,3)=(j-1)*EL2;
            nodes(numnode,2)=(anz1+1-i)*EL1;
        end
    end
    %% Berechnung der Koordinaten der Mittenknoten:
    % Berechnung der Koordinaten der Mittenknoten bei x_1=N*el1/2:
    for i=1:anz1
        for j=1:anz2+1
            numnode=eck_anz+j+(i-1)*(anz2+1);
            nodes(numnode,2) = L1-(2*i-1)*EL1/2;
            nodes(numnode,3) = (j-1)*EL2;
        end
    end
    % Berechnung der Koordinaten der Mittenknoten bei x_1=N*el1:
    for i=1:anz1+1
        for j=1:anz2
            numnode=eck_anz+anz2+1+(anz1-1)*(anz2+1)+j+(i-1)*anz2;
            nodes(numnode,2) = L1-(i-1)*EL1;
            nodes(numnode,3) = (2*j-1)*EL2/2;
        end
    end
    % Der Vektor rechts enthält alle Knoten mit x_1=L_1:
    rechts = 0;
    for k=1:length(nodes)
        if nodes(k,2) == L1
            rechts=vertcat(rechts,nodes(k,1));
        end
    end
    rechts = rechts(2:end,1);
    % Der Vektor links enthält alle Knoten mit x_1=0:
    links = 0;
    for k=1:length(nodes)
        if nodes(k,2) == 0
            links=vertcat(links,nodes(k,1));
        end
    end
    links = links(2:end,1);
    % Der Vektor oben enthält alle Knoten mit x_2=l_2:
    oben = 0;
    for k=1:length(nodes)
        if nodes(k,3) == L2
            oben=vertcat(oben,nodes(k,1));
        end
    end
    oben = oben(2:end,1);
    % Der Vektor unten enthält alle Knoten mit x_2=0:
    unten = 0;
    for k=1:length(nodes)
        if nodes(k,3) == 0
            unten=vertcat(unten,nodes(k,1));
        end
    end
    unten = unten(2:end,1);
end

    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    