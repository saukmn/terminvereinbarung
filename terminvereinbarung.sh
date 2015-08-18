#!/bin/bash
. terminvereinbarung.cfg 

function usage {
  cat << MSG
$(basename "$0") [OPTIONS]
  --help
    Shows this help message.
  -d, --datum
    Just open browser with appointment calendar if available time apears. This is default.
  -u, --uhrzeiht
    Navigate directly to available appointment times for the earliest date. NOT IMPLEMENTED YET.
  -b, --buchung
    Take first available time to register for appointment. NOT IMPLEMENTED YET.
MSG
}

function main {

  [[ $# -gt 0 ]] && [[ "$1" == "--help" ]] && usage && exit

  while true
  do
    echo "#$((++num_of_tries)) try at `date`"

    date_exists=`curl ${DATUM_URL} | grep -c ${PATTERN}`
    [[ $date_exists -gt 0 ]] && act $@

    sleep ${DELAY}
  done
}

function act {
  [[ $# -gt 0 ]] && {
    case "$1" in
      -u | --uhrzeit) 					
        # navigate to
        echo Navigating to earliest available appointment times
        open_urhzeit_url
        ;;
      -b | --buchung)
        # I'm too busy now, do it for me
        echo Trying to book appointment automatically
        book
        ;; 
      *)
        # just open the browser
        echo Opening appointment calendar
        open_datum_url
    esac
  } || open_datum_url
}

function open_datum_url {
  ${BROWSER} ${DATUM_URL}
}

function open_urhzeit_url {
  false || open_datum_url
}

function book {
  false || open_urhzeit_url
}

main $@
