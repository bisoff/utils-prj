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
cmd_state_of_all_projects(){	# pst[x] <list>|. 	# '.' for default list
	local prj_list=$1
	[ "$prj_list" == "" ] && prj_list=default
	[ "$remote_mode" == "" ] && remote_mode=false #$2
	[ "$TRACE" == "" ] && local TRACE=0 #$3
	
	trace_prj "UTILS_PRJ_HOME:\t\t$UTILS_PRJ_HOME"
	trace_prj "UTILS_PRJ_THE_HOST:\t$UTILS_PRJ_THE_HOST"
	trace_prj "remote_mode:\t\t$remote_mode"
	
	[[ "$prj_list" == "default" ]] && prj_list=$(get_current_set)
	trace_prj "prj_list:\t\t$prj_list"
	#[[ "$remote_mode" == "" ]] && -e "${red}[lib-prj.:projects_state] 'remote_mode' param is not defined !${norm} " && return

	echo
	for prj in $(cat $UTILS_PRJ_CONFIGS/$UTILS_PRJ_THE_HOST/$prj_list.list | sed -e /^$/d | tr -d '\r' | sort); do 
		prj=`echo $prj` # normalize
		prj_file=`echo $UTILS_PRJ_CONFIGS/$UTILS_PRJ_THE_HOST/$prj`
		if [[ ! -f "$prj_file" ]]; then
			#echo prj: $UTILS_PRJ_CONFIGS/$UTILS_PRJ_THE_HOST/$prj
			#cat $UTILS_PRJ_CONFIGS/$UTILS_PRJ_THE_HOST/$prj
			echo -e "${red} Project file '$prj_file' not found !${norm} "
			continue
		  fi

		#prj_file=`eval echo $prj_file` # cut <CR> 
		trace_prj "prj_file:\t\t$prj_file" 

		prj_path=`sed -E -n 's/^path=([^#]+).*/\1/p' "$prj_file" | tr -d '\r'` 
		prj_path=`eval echo $prj_path` # for osx replace ~ to $HOME (and cut <CR>?)
		trace_prj "prj_path:\t\t$prj_path"
		[[ ! -d "$prj_path" ]] && echo -e "${red} Project path '$prj_path' not found !${norm} " && continue
		(
		eval cd "$prj_path"

		changes=$(gis | wc -l) 
		trace_prj "changes:\t\t$changes"
		#	echo -e "${grey}$prj: $prj_path${norm}"
		#  else

		echo -e "${grey_back} $prj_list  $prj \t $prj_path ${norm}"
		[ $changes -ne 0 ] && git status -s --untracked-files

		local sync_status=$(get_sync_status $remote_mode notice NO_TRACE)
		echo
		)
	  done
	}
cmd_save_all_projects(){	# psavall <list>|. [<msg>]
	# psavall <msg> <list>  # save every prj in list (add/commit/push)
	trace_prj=$1
	msg=$2

	trace_prj "UTILS_PRJ_HOME:\t\t$UTILS_PRJ_HOME"
	trace_prj "UTILS_PRJ_THE_HOST:\t$UTILS_PRJ_THE_HOST"

	[[ "$trace_prj" == "." ]] && trace_prj="" # trik to save default
	[[ "$trace_prj" == "" ]] && trace_prj=$(get_current_set)
	trace_prj "prj_list:\t\t$prj_list" # get default repos list

	echo
	for prj in $(cat $UTILS_PRJ_CONFIGS/$UTILS_PRJ_THE_HOST/$trace_prj.list | tr -d '\r' | sort); do 
		prj_path=`sed -E -n 's/^path=([^#]+).*/\1/p' $UTILS_PRJ_CONFIGS/$UTILS_PRJ_THE_HOST/$prj | tr -d '\r'` # sed -E -n 's/^path=([^#]+)/\1/p' /Users/a.bysov/prj/utils-vcs/.cfg/ok/ue
		(
		eval cd "$prj_path" # for osx replace ~ to $HOME
		changes=$(gis | wc -l)	# echo changes: $changes
		echo -e "${grey_back} $trace_prj  $prj \t $prj_path${norm}"
		trace_prj "prj_path:\t\t$prj_path"
		trace_prj "changes:\t\t$changes" # 2> /dev/null 
		if [[ "$changes" == "0" ]]; then
			local sync_remote_status=$(get_sync_status remote silent NO_TRACE)
			trace_prj "sync_remote_status:\t$sync_remote_status" # 2> /dev/null 
		  fi

		if [ "$changes" != "0" ]; then
			gok "$msg" # TODO: переделать на использование либы 
		  fi
		if [[ "$changes" == "0" && "$sync_remote_status" == "push" ]]; then
			gus
		  fi
		[[ "$sync_remote_status" != "push" && "$sync_remote_status" != "ok" ]] && show_sync_status "$status"
		echo
		)
	  done
	# TODO: test uncommited (untracked, changed, deleted, staged)
	}
cmd_save_all_projects_at_local(){ # pfixall <list>|. [<msg>]
	# pfixall <prj> <msg> # add/commit
	prj_list=$1
	msg=$2

	trace_prj "UTILS_PRJ_HOME:\t$UTILS_PRJ_HOME"
	trace_prj "UTILS_PRJ_THE_HOST:\t$UTILS_PRJ_THE_HOST"

	[[ "$prj_list" == "." ]] && prj_list="" # trik to save default
	[[ "$prj_list" == "" ]] && prj_list=$(get_current_set)
	trace_prj "prj_list:\t\t$prj_list"

	for prj in $(cat $UTILS_PRJ_CONFIGS/$UTILS_PRJ_THE_HOST/$prj_list.list | tr -d '\r' | sort); do 
		prj_path=`sed -E -n 's/^path=([^#]+).*/\1/p' $UTILS_PRJ_CONFIGS/$UTILS_PRJ_THE_HOST/$prj | tr -d '\r'` # sed -E -n 's/^path=([^#]+)/\1/p' /Users/a.bysov/prj/utils-vcs/.cfg/ok/ue
		(
		eval cd "$prj_path"
		changes=$(gis | wc -l)	# echo changes: $changes
		echo -e "\n${grey_back} $prj_list  $prj \t $prj_path${norm} "
		if [ $changes -ne 0 ]; then
			gac "$msg" # TODO: переделать на использование либы 
			echo
		  fi
		#${red}none${norm}"
		)
	  done
	#echo
	}

cmd_pull_all_projects(){	# pgetall <list>|.
	# pgetall <list> # save every prj in list (add/commit/push)
	prj_list=$1

	# echo home: $home
	# echo UTILS_PRJ_THE_HOST: $UTILS_PRJ_THE_HOST
	[[ "$prj_list" == "." ]] && prj_list="" # trik to set default
	[[ "$prj_list" == "" ]] && prj_list=$(get_current_set)
	trace_prj "prj_list:\t\t$prj_list" # get default repos list

	for prj in $(cat $UTILS_PRJ_CONFIGS/$UTILS_PRJ_THE_HOST/$prj_list.list | tr -d '\r' | sort ); do 
		prj_path=`sed -E -n 's/^path=([^#]+).*/\1/p' $UTILS_PRJ_CONFIGS/$UTILS_PRJ_THE_HOST/$prj | tr -d '\r'` # sed -E -n 's/^path=([^#]+)/\1/p' /Users/a.bysov/prj/utils-vcs/.cfg/ok/ue
		(
		eval cd "$prj_path"
		echo -e "\n ${grey_back} $prj_list  $prj \t $prj_path ${norm}"
		changes=$(gis | wc -l) 
		trace_prj "changes:\t\t$changes" # 2> /dev/null 

		if [[ $changes -eq 0  ||  "$changes" == "" ]]; then
			compare_status=$(get_sync_status remote silent NO_TRACE)
			trace_prj "compare_status:\t$compare_status"
			[ "$compare_status" == "diverged" ] && echo -e "${red_bright}DIVERGED ! NEED TO PUSH AFTER ${norm}" # 
			if [[ "$compare_status" == "pull" || "$compare_status" == "diverged" ]]; then
				gul
				git diff --stat=200 HEAD~1 HEAD --color | sed -n '$! p' # files in last commit 
			  fi
		  else
    		  	gis
		  fi
		)
	  done
	# TODO: test uncommited (untracked, changed, deleted, staged)
	}

