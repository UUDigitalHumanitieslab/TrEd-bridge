import tkinter as tk


class TextWithCallback(tk.Text):
    def __init__(self, *args, **kwargs):
        tk.Text.__init__(self, *args, **kwargs)
        self._orig = self._w + "_orig"
        self.tk.call("rename", self._w, self._orig)
        self.tk.createcommand(self._w, self._proxy)

    def _proxy(self, *args):
        cmd = (self._orig,) + args
        try:
            result = self.tk.call(cmd)
        except Exception:
            return None

        if (args[0] in ("insert", "delete") or
                args[0:3] == ("mark", "set", "insert")):
            self.event_generate("<<TextChanged>>", when="tail")

        return result
