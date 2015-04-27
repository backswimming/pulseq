function parsemr(seqFiles)
%PARSEMR Load a sequence file and display a summary of the sequence events
%   PARSEMR(filename) Load a single file and display a summary of the
%   sequence
%
%   PARSEMR({file1,file2}) Load each filename in the cell array and display
%   a summary of the sequence
%
%   See also mr.Sequence

try
    seq=mr.Sequence();
    seqFiles = cellstr(seqFiles);
    
    for i=1:length(seqFiles)
        file=seqFiles{i};
        
        % Read file
        seq.read(file);
        
        % Loop over blocks and gather statistics
        numBlocks = size(seq.blockEvents,1);
        eventCount=zeros(1,size(seq.blockEvents,2));
        duration=0;
        for iB=1:numBlocks
            b=seq.getBlock(iB);
            eventCount = eventCount + (seq.blockEvents(iB,:)>0);
            duration=duration+mr.calcDuration(b);
        end
        
        % Open output file for writing
        [outDir,outFile,~]=fileparts(file);
        fid=fopen([outDir '/' outFile '.matlab.out'],'w');
        fprintf(fid,'Testing file: %s\n',file);
        fprintf(fid,'Number of blocks: %d\n',numBlocks);
        fprintf(fid,'Number of events:\n');
        fprintf(fid,'   RF:   %6d\n',eventCount(2));
        fprintf(fid,'   Gx:   %6d\n',eventCount(3));
        fprintf(fid,'   Gy:   %6d\n',eventCount(4));
        fprintf(fid,'   Gz:   %6d\n',eventCount(5));
        fprintf(fid,'   ADC:  %6d\n',eventCount(6));
        fprintf(fid,'   Delay:%6d\n',eventCount(1));
        fprintf(fid,'Sequence duration: %.4fs\n',duration);
        
        fclose(fid);
    end
catch e
    disp(e)
    fprintf('Error detected, exiting MATLAB...\n');
    %exit();
end
