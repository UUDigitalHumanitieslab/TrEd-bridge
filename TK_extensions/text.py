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


class ReadonlyText(tk.Text):
    def __init__(self, parent, label=None, default=None, *args, **kwargs):
        tk.Text.__init__(self, parent,
                         height=1,
                         borderwidth=1,
                         wrap=tk.WORD,
                         font=kwargs.get('font') or ('Roboto', 16),
                         background=kwargs.get('bg') or "lightgrey",
                         foreground=kwargs.get('fg') or "black",
                         highlightthickness=0,
                         *args, **kwargs)
        self.label = label
        self.tag_configure('tag-center', justify='center')
        self.configure(state='disabled')
        self.bind(
            "<Button>", lambda event: self.focus_set())
        if default:
            self.set_readonly(default)

    def set_readonly(self, text):
        self.configure(state='normal')
        self.delete('1.0', tk.END)
        if self.label:
            ins = '{} :\n{}'.format(self.label, text)
        else:
            ins = text
        self.insert(tk.END, ins, 'tag-center')
        self.configure(state='disabled')
