function boxes = ReadDetectionResults(filename)

fid = fopen(filename, 'r');
boxes = cell(1, 507);
while ~feof(fid)
    nextline = fgets(fid);
    imageid = sscanf(nextline, '%s', 1);
    
    nextline = fgets(fid);
    x = sscanf(nextline, '%f');
    assert(length(x) == 68);
    
    nextline = fgets(fid);
    y = sscanf(nextline, '%f');
    assert(length(y) == 68);
    
    nextline = fgets(fid);
    occ = sscanf(nextline, '%d');
    assert(length(occ) == 68);
    
    id = str2num(imageid);
    assert(isempty(boxes{id}));
    boxes{id}.pts68 = [x y];
    boxes{id}.occ68 = occ;
end
fclose(fid);
