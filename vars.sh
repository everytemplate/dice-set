every pick universe.sreg kind.id kind.rev "$@" | awk '{print "SET_REG="$1, "KIND_ID="$2, "KIND_REV="$3}'
