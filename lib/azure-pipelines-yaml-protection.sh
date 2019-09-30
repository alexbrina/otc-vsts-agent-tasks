#-----------------------------
# Depends on assert.sh; git.sh
#-----------------------------

function azure-pipelines-yaml-protection
{
	assert-not-empty SYSTEM_PULLREQUEST_PULLREQUESTID
	local pullrequest_id=$SYSTEM_PULLREQUEST_PULLREQUESTID
	local diff_result_file=$(mktemp -t "pr-az-pl-yaml-protec-${pullrequest_id}-XXXXXXXX")
	echo "Modified items without filter:"
	git-diff $(get-base-branch) $pullrequest_id > $diff_result_file
	cat $diff_result_file
	if cat $diff_result_file | \
		egrep '^[0-9]+[ '$'\t]+[0-9]+[ '$'\t]+azure-pipelines\.yml$' > /dev/null 2>&1
	then
		red "******************************************************************"
		red "* azure-pipelines.yml should not be modified in topic branches.  *"
		red "******************************************************************"
		exit 47 # Critical, pipeline must not procceed.
	fi
}
