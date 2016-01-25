function res=mocov_find_files(root_dir, file_pat, monitor)
% Finds files recursively in a directory
%
% res=mocov_find_files([root_dir[, file_pat]])
%
% Inputs:
%   root_dir            Optional directory in which files are sought.
%                       If not provided or empty, the current working
%                       directory is used.
%   file_pat            Optional wildcard pattern, e.g. '*.m' for all
%                       files ending with '.m'. If omitted, the pattern '*'
%                       is used, corresponding to all files.
%   monitor             Optional progress monitory that supports a
%                       'notify' method.
%
% Output:
%   res                 Kx1 cell with names of files in root_dir matching
%                       the pattern.
%
% NNO May 2015

    if nargin<1
        root_dir='';
    end

    if ~(isempty(root_dir) || isdir(root_dir))
        error('first argument must be directory');
    end

    if nargin<2
        file_pat='*';
    end

    if nargin<3
        monitor=[];
    end

    file_re=['^' ... % start of the string
             regexptranslate('wildcard',file_pat) ...
             '$'];   % end of the string


    if ~isempty(monitor)
        msg=sprintf('Finding files matching %s from %s',file_pat,root_dir);
        notify(monitor, msg);
    end

    res=find_files_recursively(root_dir,file_re,monitor);

function res=find_files_recursively(root_dir,file_re,monitor)
    if isempty(root_dir)
        dir_arg={};
    else
        dir_arg={root_dir};
    end

    d=dir(dir_arg{:});
    n=numel(d);

    res_cell=cell(n,1);
    for k=1:n
        fn=d(k).name;

        ignore_fn=strcmp(fn,'.') || strcmp(fn,'..');

        res=cell(0,1);
        if ~ignore_fn
            path_fn=fullfile(root_dir, fn);

            if isdir(path_fn)
                res=find_files_recursively(path_fn,file_re,monitor);
            elseif ~isempty(regexp(fn,file_re,'once'));
                res={path_fn};
                if ~isempty(monitor)
                    notify(monitor,'.',path_fn);
                end
            end
        end
        res_cell{k}=res;
    end

    res=cat(1,res_cell{:});