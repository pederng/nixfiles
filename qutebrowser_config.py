config.load_autoconfig(False)
c.bindings.key_mappings = {
    "<Ctrl-[>": "<Escape>",
    "<Ctrl-6>": "<Ctrl-^>",
    "<Ctrl-M>": "<Return>",
    "<Shift-Return>": "<Return>",
    "<Enter>": "<Return>",
    "<Shift-Enter>": "<Return>",
    "<Ctrl-Enter>": "<Ctrl-Return>",
}
c.completion.cmd_history_max_items = 100
c.content.webgl = False
c.fonts.completion.category = "bold 10pt monospace"
c.fonts.completion.entry = "10pt monospace"
c.fonts.debug_console = "10pt monospace"
c.fonts.downloads = "10pt monospace"
c.fonts.hints = "bold 10pt monospace"
c.fonts.keyhint = "10pt monospace"
c.fonts.messages.error = "10pt monospace"
c.fonts.messages.info = "10pt monospace"
c.fonts.messages.warning = "10pt monospace"
c.fonts.default_family = [
    "DejaVu Sans Mono",
    "Hack Nerd Font Mono",
    "xos4 Terminus",
    "Terminus",
    "Monospace",
    "Monaco",
    "Bitstream Vera Sans Mono",
    "Andale Mono",
    "Courier New",
    "Courier",
    "Liberation Mono",
    "monospace",
    "Fixed",
    "Consolas",
    "Terminal",
]
c.fonts.prompts = "10pt sans-serif"
c.fonts.statusbar = "10pt monospace"
# c.fonts.tabs = "10pt monospace"
c.tabs.position = "left"
c.tabs.width = "10%"
try:
    import custom_config
    c.zoom.default = custom_config.ZOOM
except (ImportError, AttributeError):
    c.zoom.default = '100%'
config.bind("<Ctrl-K>", "completion-item-focus prev", mode="command")
config.bind("<Ctrl-J>", "completion-item-focus next", mode="command")

c.url.searchengines = {
    "DEFAULT": "https://duck.com/?q={}",
    "ddg": "https://duck.com/?q={}",
    "ddgl": "https://lite.duckduckgo.com/lite?q={}",
}
