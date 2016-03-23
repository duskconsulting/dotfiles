:<<COMMENT
    Deletes all lines from the history that match a search string, with a
    prompt. The history file is then reloaded into memory.

    Short description: Stored in HXF_DESC

    Examples
        hxf "rm -rf"
        hxf ^source

    Parameter is required, and must be at least one non-whitespace character.

    With the following setting, this is *not* added to the history:
        export HISTIGNORE="*hxf *"
    - http://superuser.com/questions/232885/can-you-share-wisdom-on-using-histignore-in-bash

    See:
    - http://unix.stackexchange.com/questions/57924/how-to-delete-commands-in-history-matching-a-given-string
COMMENT

HXF_DESC="hxf [searchterm]: Delete all history items matching search term, with y/n prompt."

hxf()  {
    # Exit if no parameter is provided (if it's the empty string)
        param=$(echo "$1" | trim)
        # echo "$param"
        if [ -z "$param" ]  # http://tldp.org/LDP/abs/html/comparison-ops.html
        then
          echo "Required parameter missing. Cancelled."; return
        fi

    read -r -p "About to delete all items from history that match \"$param\". Are you sure? [y/N] " response
    if [[ $response =~ ^(yes|y)$ ]]
    then
        # Delete all matched items from the file, and duplicate it to a temp
        # location.
        grep -v "$param" "$HISTFILE" > /tmp/history

        # Clear all items in the current sessions history (in memory). This
        # empties out $HISTFILE.
        history -c

        # Overwrite the actual history file with the temp one.
        mv /tmp/history "$HISTFILE"

        # Now reload it.
        history -r "$HISTFILE"     # Alternative: exec bash
    else
        echo "Cancelled."
    fi
}
