runlog() {
  echo "" | tee -a evidence/terminal.log
  echo "$ $*" | tee -a evidence/terminal.log
  bash -lc "$*" 2>&1 | tee -a evidence/terminal.log
}
