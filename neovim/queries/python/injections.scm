; extends

((string) @html
 (#contains? @html "<a" "<b" "<h" "<i" "<p"))

((string) @sql
 (#contains? @sql "SELECT" "INSERT" "UPDATE" "DELETE" "CREATE" "REPLACE" "ALTER"
                  "select" "insert" "update" "delete" "create" "replace" "alter"))
