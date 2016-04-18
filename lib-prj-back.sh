#!/bin/bash
cmd_state_of_one_project(){	# pstate[x] <prj>
	# pstate <prj>
	prj=$1
	[ "$remote_mode" == "" ] && remote_mode=false #$2

	# echo home: $home
	# echo UTILS_PRJ_THE_HOST: $UTILS_PRJ_THE_HOST
	( # to return current path
	if [[ "$prj" == "" ]]; then 
		curr_path=`eval echo $(pwd)`; trace_prj "cur_path:\t$curr_path"
		prj_name=$(get_project_name $curr_path dont_TRACE); trace_prj "prj_name:\t$prj_name"
		[[ "$prj_name" == "" ]] && echo "[SAVE PROJECT] project name is missed  and  not found by 'current path' in $UTILS_PRJ_CONFIGS/$UTILS_PRJ_THE_HOST !" && return
	  else
		# find prj file by current path
		prj_path=$(get_project_path $prj NO_TRACE) #"$UTILS_PRJ_CONFIGS/$UTILS_PRJ_THE_HOST" 
		# TODO: get prj vcs_type (svn, git)
		echo -e "$prj:\t$prj_path"
		eval cd "$prj_path"
	  fi
	gis
	sync_status=$(get_sync_status "$remote_mode" "notice" "NO_TRACE")
	)
	}
cmd_save_one_projects(){	# psave <prj>|. [<msg>]
	# psave <prj> <msg> # save prj-repo (add/commit/push)
	# todo: . <msg>
	# to TRACE - 'bp; TRACE=1; psave kj'
	local prj=$1
	local msg=$2
	
	[ "$prj" == "" ] && echo -e "${green}psave ${yellow}<prj>|<.> [<msg>]${norm}" && return 
	trace_prj "prj:\t\t$prj"
	# echo UTILS_PRJ_HOME: $UTILS_PRJ_HOME
	# echo UTILS_PRJ_THE_HOST: $UTILS_PRJ_THE_HOST
	#default_repos=$(get_current_set) 	# echo default_repos: $default_repos  # get default repos  

	if [[ "$prj" == "." ]]; then 
		curr_path=`eval echo $(pwd)` #; echo cur_path:$curr_path
		prj_name=$(get_project_name $curr_path)
		trace_prj "prj_name:\t$prj_name"
		[[ "$prj_name" == "" ]] && echo "[SAVE PROJECT] project name is missed  and  not found by 'current path' in $UTILS_PRJ_CONFIGS/$UTILS_PRJ_THE_HOST !" && return
		# save prj
		echo "SAVING $prj_name: $curr_path"
		gok "$msg"
		return
	  fi

	# find prj file by current path
	local prj_path=$(get_project_path $prj NO_TRACE)
	trace_prj "prj_path:\t$prj_path" #"$UTILS_PRJ_CONFIGS/$UTILS_PRJ_THE_HOST" 
	[ "$prj_path" == "" ] && echo -e "${red}[SAVE PROJECT] prj_path not found !${norm}" && return
	local prj_path_norm=`eval echo $prj_path`
	trace_prj "prj_path_norm:\t$prj_path_norm"
	#[[ "$prj_path_norm" == "" ]] && echo -e "${red}[SAVE PROJECT] project file '$UTILS_PRJ_CONFIGS/$UTILS_PRJ_THE_HOST/$prj' not found !${norm}" && return
	[[ ! -d "$prj_path_norm" ]] && echo -e "${red}[SAVE PROJECT] project path '$prj_path_norm' not found !${norm}" && return
	# TODO: get prj vcs_type (svn, git)
	# TODO: get prj remote

	( # to return current path
	echo -e "prj_path:\t$prj_path"
	eval cd "$prj_path"
	gok "$msg" 
	)
	# TODO: test uncommited (untracked, changed, deleted, staged)
	}
cmd_save_one_project_at_local(){ # pfix <prj> <msg>
	# pfix <prj> <msg> # save prj-repo (add/commit/push)

	prj=$1
	msg=$2

	# echo UTILS_PRJ_THE_HOST: $UTILS_PRJ_THE_HOST
	#default_repos=$(get_current_set) 	# echo default_repos: $default_repos  # get default repos  

	if [[ "$prj" == "" ]]; then 
		curr_path=`eval echo $(pwd)` #; echo cur_path:$curr_path
		prj_name=$(get_project_name $curr_path) #; echo prj_name: $prj_name
		[[ "$prj_name" == "" ]] && echo "[SAVE PROJECT] project name is missed  and  not found by 'current path' in $UTILS_PRJ_CONFIGS/$UTILS_PRJ_THE_HOST !" && return
		# save prj
		echo "SAVING $prj_name: $curr_path"
		gac "$msg" 
		return
	  fi

	# find prj file by current path
	prj_path=$(get_project_path $prj NO_TRACE) #"$UTILS_PRJ_CONFIGS/$UTILS_PRJ_THE_HOST"
	[[ "$prj_path" == "" ]] && echo  "[SAVE PROJECT] project file '$UTILS_PRJ_CONFIGS/$UTILS_PRJ_THE_HOST/$prj' not found !" && return
	# TODO: get prj vcs_type (svn, git)
	# TODO: get prj remote
	( # to return current path
	echo "$prj: $prj_path"
	eval cd "$prj_path"
	gac "$msg" 
	)

	# TODO: test uncommited (untracked, changed, deleted, staged)
	}
cmd_pull_one_project(){		# pget 	<prj> 
	# pget <prj> 

	#TRACE=0
	prj=$1
	msg=$2
	#[ $TRACE == 1 ] && echo start
	[ $TRACE == 1 ] && echo -e "UTILS_PRJ_THE_HOST:\t$UTILS_PRJ_THE_HOST"

	curr_path=$(pwd) ; [ $TRACE == 1 ] && echo curr_path: $curr_path	
	if [[ "$prj" == "" ]]; then 
		curr_path=`eval echo $(pwd)` #; echo cur_path:$curr_path
		prj_name=$(get_project_name $curr_path NO_TRACE) #; echo prj_name: $prj_name
		[[ "$prj_name" == "" ]] && echo "[SAVE PROJECT] project name is missed  and  not found by 'current path' in $UTILS_PRJ_CONFIGS/$UTILS_PRJ_THE_HOST !" && return
		# get prj (update)
		echo "GETTING $prj_name: $curr_path"
		gul
		return
	  fi

	# find prj file by current path
	prj_path=$(get_project_path "$prj" NO_TRACE); [ $TRACE == 1 ] && echo prj_path: $prj_path # "$UTILS_PRJ_CONFIGS/$UTILS_PRJ_THE_HOST"
	[[ "$prj_path" == "" ]] && echo -e "${red}[PROJECT GET] Project path not found (by name: $prj) ! ${norm}" && return
	# TODO: get prj vcs_type (svn, git)
	# TODO: get prj remote
	( # to return current path
	echo "$prj: $prj_path"
	eval cd "$prj_path"
	gul "$msg" 
	)
	# TODO: test uncommited (untracked, changed, deleted, staged)
	}