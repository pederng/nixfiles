local command = vim.api.nvim_create_user_command

-- :W is too easy to type by accident
command('W', 'w', {})
command('Wq', 'wq', {})
command('WQ', 'wq', {})
command('Wqa', 'wqa', {})

command('SQL', 'enew | setlocal buftype=nofile | setlocal ft=pgsql', {})
