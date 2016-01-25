function md5=mocov_util_md5(filename)
% return the md5sum from the contents of a file
%
% md5=mocov_util_md5(filename)
%
% Inputs:
%   filename            name of file for which md5 must be computed
%
% Output:
%   md5                 md5 checksum of the contents of the file filename
%
% Notes:
%    - this function requires either the presence of a function named
%      'md5sum' (available on the GNU Octave platform), or the usage of a
%      unix-like platform
%
%
    md5_with_whitespace=md5_from_file(filename);
    md5=regexprep(md5_with_whitespace,'\s','');%


function md5=md5_from_file(fn)
    md5_processors={@md5_builtin,@md5_shell};

    n=numel(md5_processors);
    for k=1:n
        md5_processor=md5_processors{k};
        [is_ok,md5]=md5_processor(fn);
        if is_ok
            return;
        end
    end

    error('Unable to compute md5 - no method available');

function [is_ok,md5]=md5_builtin(fn)
% supported in GNU Octave
    is_ok=~isempty(which('md5sum'));
    if is_ok
        md5=md5sum(fn);
    else
        md5=[];
    end

function [is_ok,md5]=md5_shell(fn)
% supported on Unix platform
    is_ok=false;
    md5=[];

    if ispc()
        return;
    end

    cmd=sprintf('md5 -q "%s"',fn);
    [status,md5]=unix(cmd);
    is_ok=status==0;









