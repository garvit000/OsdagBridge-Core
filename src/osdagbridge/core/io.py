"""IO helpers for YAML/JSON"""
def load_project(path: str):
    with open(path, 'r') as f:
        return f.read()
