; extends

(assignment
  left: (identifier) @_id (#match? @_id "q")
  right: (string) @sql)
(assignment
  left: (identifier) @_id (#match? @_id "sql")
  right: (string) @sql)
