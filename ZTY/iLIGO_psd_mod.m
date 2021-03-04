function iLIGO_mod = iLIGO_psd_mod(iLIGO,sampFreq)
iLIGO_mod = zeros(size(iLIGO));
for i = 1:length(iLIGO(:,1))
    iLIGO_mod(i,1) = iLIGO(i,1);
    if (iLIGO(i,1) < 50 & iLIGO(i+1,1) > 50)
        iLIGO_mod(1:i,2) = iLIGO(i,2)*ones(i,1);
    
    elseif (iLIGO(i,1) < 700 & iLIGO(i+1,1) > 700)
        iLIGO_mod(i,2) = iLIGO(i,2);
        iLIGO_mod(i+1:end,1) = iLIGO(i+1:end,1);
        iLIGO_mod(i+1:end,2) = iLIGO(i,2)*ones(length(iLIGO(:,1)) - i,1);
        break
    else
        iLIGO_mod(i,2) = iLIGO(i,2);
    end
end
for i = 1:length(iLIGO_mod(:,1))
    if (iLIGO(i,1) < sampFreq/2 & iLIGO(i+1,1) > sampFreq/2)
        tmp1 = iLIGO(i+1:end,:);
        iLIGO_mod(i+1,:) = [sampFreq/2, (iLIGO(i,2) + iLIGO(i+1,2))/2];
        %iLIGO_trunc = iLIGO_mod(1:i+1,:);
        iLIGO_mod = [iLIGO_mod(1:i+1,:);tmp1];
        break
    end
end
tmp = [[0,iLIGO_mod(1,2)];iLIGO_mod];
iLIGO_mod = tmp;

%tmp = [[0,iLIGO_mod(1,2)];iLIGO_trunc];
%iLIGO_trunc = tmp;
end
