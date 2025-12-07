"""Plugin registration (stub)."""
_plugins = {}
def register(name, obj):
    _plugins[name] = obj
