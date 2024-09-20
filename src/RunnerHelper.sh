#!/bin/bash

source ./src/RunnerConf.sh

download_tar() {
    echo -e "⬇️  Download : $F_RUNNER_TAR\n"
    curl -o $F_RUNNER_TAR -L $URL_DOWNLOAD/$F_RUNNER_TAR
    echo "$C_RUNNER_TAR  $F_RUNNER_TAR" | shasum -a 256 -c
}

validate_token() {
    local token=$1
    if [ -z $token ]; then
        echo -e $T_MISSING_TOKEN; echo -e $T_TOKEN_FORMAT; exit 1
    else
        if ! [ ${#token} -eq $C_TOKEN_SIZE ]; then
            echo -e $T_INVALID_TOKEN; echo -e $T_TOKEN_FORMAT; exit 1
        fi
    fi
}

validate_runner_id() {
    runnerID=$1
    if [ -z $runnerID ]; then
        echo -e $T_MISSING_ID; echo -e $T_ID_FORMAT; exit 1
    else
        if ! [ ${#runnerID} -eq $C_RUNNER_ID_SIZE ]; then
            echo -e $T_INVALID_ID; echo -e $T_ID_FORMAT; exit 1  
        fi
    fi
}

log_runner_info() {
    # https://patorjk.com/software/taag/#p=display&f=Big&t=
    echo -e "--------------------------------------------------------------------------------"
    echo -e "                                                    ⢀       ⣀⣀⡤⠤⠤⠤⣄⣀⡀"
    echo -e "                                                   ⢴⠋⠙⠳⣤⡀⣠⠖⠋⠁       ⠉⠓⠤⡀⣠⡴⠟⠛⣷"
    echo -e "           _       _       _  ____   _____         ⠈⠳⢤⣀⢈⠟⠁             ⠘⢏⣀⣠⡴⠋"
    echo -e "     /\   (_)     | |     (_)/ __ \ / ____|       ⢀⣠⣤⣄⣄⣉⡏                ⠈⣇⣡⣤⡴⣦⣀"
    echo -e "    /  \   _  ___ | | ___  _| |  | | (___         ⢹⣅⡀  ⠈⡇                 ⡏⠁ ⢀⣠⠏"
    echo -e "   / /\ \ | |/ _ \| |/ _ \| | |  | |\___ \         ⠈⠙⠉⢋⣉⣇  ⣾⣷⠄       ⢴⣿⡆ ⢀⣿⡙⠋⠋"
    echo -e "  / ____ \| | (_) | | (_) | | |__| |____) |         ⢤⠶⠋⠉⢈⣦⡀⠈⠉   ⠉⠉⠉   ⠉ ⣠⣎⠈⠉⠛⢷⡀"
    echo -e " /_/  __\_\ |\___/|_|\___/|_|\____/|_____/_         ⠻⣤⣤⠶⠋ ⠈⠑⠠⠄⣀⣀⣀⣀⣀⣀⡀⠤⠐⠉ ⠈⠻⠶⠖⠶⠃"
    echo -e " |  \/  |_/ |       / ____| |          | (_)                ⢠⠃⠤⡀ ⡠⠤⢱"
    echo -e " | \  / |__/ _  ___| (___ | |_ __ _  __| |_ _   _ _ __ ___  ⡎ ⠉⠁ ⠉⠉ ⡇"
    echo -e " | |\/| |/ _\` |/ __|\___ \| __/ _\` |/ _\` | | | | | '_ \` _ \ ⡇⢀⠤⡀ ⡠⢄⢀⠇"
    echo -e " | |  | | (_| | (__ ____) | || (_| | (_| | | |_| | | | | | |⠘⠢⣀⣀⣀⣈⡠⠊"
    echo -e " |_|  |_|\__,_|\___|_____/ \__\__,_|\__,_|_|\__,_|_| |_| |_|  ⡌⡇ ⣎⠇"
    echo -e "                                                              ⢡⡇⣸⠜"
    echo -e "                                                               ⠓⠉"
    echo -e "--------------------------------------------------------------------------------"
    echo -e "  ◉ name          : $C_RUNNER_NAME"
    echo -e "  ◉ token         : $C_TOKEN"
    echo -e "  ◉ workspace     : $D_RUNNER"
    echo -e "  ◉ organization  : $C_ORG"
    echo -e "  ◉ runners-group : $C_GROUP"
    echo -e "  ◉ labels        : $C_LABELS"
    echo -e "--------------------------------------------------------------------------------"
}

download_installer() {    
    if [ ! -d $D_DOWNLOADS ]; then
        mkdir $D_DOWNLOADS
    fi
    cd $D_DOWNLOADS
    if ! [ -f $F_RUNNER_TAR ]; then
       download_tar
    else
        if ! [ $(stat -f%z $F_RUNNER_TAR) -eq $C_RUNNER_TAR_SIZE ]; then
            rm $F_RUNNER_TAR
            download_tar
        fi
    fi    
    cd ..    
}

create_runner_folder() {    
    if [ ! -d $D_RUNNERS ]; then
        mkdir $D_RUNNERS; cd $D_RUNNERS        
    else
        cd $D_RUNNERS
    fi
    if [ -d $D_RUNNER ]; then
        rm -r $D_RUNNER
    fi
    mkdir $D_RUNNER; cd  $D_RUNNER    
    if ! [ -f $F_RUNNER_TAR ]; then
        cp "./../../$D_DOWNLOADS/$F_RUNNER_TAR" $F_RUNNER_TAR
    fi        
    if ! [ -f $F_CONFIG ]; then
        tar xzf ./$F_RUNNER_TAR
    fi
    rm $F_RUNNER_TAR
}

start_runner() {
    ./config.sh --url $URL_ORG --token $C_TOKEN --labels $C_LABELS --name $C_RUNNER_NAME --runnergroup $C_GROUP
    ./run.sh
}

setupRunner() {
    C_TOKEN=$1
    C_RUNNER_NAME="$C_ORG-Rnr-$2"
    D_RUNNER="$C_RUNNER_NAME-Workspace"
    log_runner_info
    download_installer        
    create_runner_folder 
    start_runner 
}