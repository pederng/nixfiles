((string) @sql (#contains? @sql "SELECT" "INSERT" "UPDATE" "DELETE" "CREATE" "ALTER") (#offset! @sql 1 0 -1 0))

(call
  (attribute
    object: (identifier) @object (#eq? @object "crs")
    attribute: (identifier) @_attribute (#contains? @_attribute "execute" "executemany"))
  (argument_list
    (string
      (string_content) @injection.content
        (#set! injection.language "sql"))))
