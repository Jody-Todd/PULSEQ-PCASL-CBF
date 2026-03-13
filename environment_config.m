function [env] = environment_config()
    %% user config
    script_dir='.'; % where did you put this script itself? if you call it from current directory, leave it unchanged.
    spm12_dir='/usr/local/spm12/'; %if you are using bitc cluster, no change required.
    %% user configuration ends here.

    env.spm12_dir=spm12_dir;
    addpath(spm12_dir);
    if (~isdir(sprintf('%s/plugins/', script_dir)))
        disp('missing plugins folder in script_dir. will try current folder instead');
        script_dir='.';
    else
        cd(script_dir)
    end
    env.script_dir = pwd;
    addpath(env.script_dir)
    addpath([env.script_dir, '/plugins/NIfTI_20140122/']);
    addpath([env.script_dir, '/plugins/eja_rdMeas/']);
end