function queryList = createQueries(fileName)

delimiter = ',';

synapseQueries = read_mixed_csv(fileName, delimiter);

queryList = cell(ceil(size(synapseQueries, 1) / 3), 1);

itr = 1; 

for n=1:3:size(synapseQueries, 1)
    query = parseQuery(synapseQueries(n, :), synapseQueries(n+1, :));
    queryList{itr} = query; 
    itr = itr + 1; 
    
end

end

function query = parseQuery(preLine, postLine)

query.preIF = {};
query.preIF_z = [];
query.postIF = {};
query.postIF_z = [];

itr = 1;
for n=1:2:length(preLine)
    if strcmp(preLine{n}, 'NULL')
        query.preIF = {'NULL'};
        break;
    elseif isempty(preLine{n})
        break;
    end
    
    query.preIF{itr} = preLine{n};
    query.preIF_z(itr) = str2num(preLine{n+1});
    itr = itr + 1;
end

itr = 1;
for n=1:2:length(postLine)
    if strcmp(postLine{n}, 'NULL')
        query.postIF = {'NULL'};
        break;
    elseif isempty(postLine{n})
        break;
    end
    
    query.postIF{itr} = postLine{n};
    query.postIF_z(itr) = str2num(postLine{n+1});
    itr = itr + 1;
end


end


