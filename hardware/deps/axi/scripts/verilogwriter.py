class Signal(object):
    def __init__(self, name, width=0, low=0, asc=False, vec=0):
        self.name = name
        self.width=width
        self.low = low
        self.asc = asc

    def range(self):
        if self.width > 0:
            l = self.width+self.low-1
            r = self.low
            if self.asc:
                return '['+str(r)+':'+str(l)+']'
            else:
                return '['+str(l)+':'+str(r)+']'
        return ''

class Wire(Signal):
    def write(self, width):
        return 'wire{range} {name};\n'.format(range=self.range().rjust(width), name=self.name)

class Port:
    def __init__(self, name, value):
        self.name = name
        self.value = value

class ModulePort(Signal):
    def __init__(self, name, dir, width=0, low=0, asc=False):
        super(ModulePort, self).__init__(name, width, low, asc)
        self.dir = dir

    def write(self, range_width=0):
        return '{dir} wire {range} {name}'.format(dir=self.dir.ljust(6), range=self.range().rjust(range_width), name=self.name)

class Instance:
    def __init__(self, module, name, parameters, ports):
        self.module = module
        self.name = name
        self.parameters = parameters
        self.ports = ports

    def write(self):
        s = self.module
        if self.parameters:
            max_len = max([len(p.name) for p in self.parameters])
            s += '\n  #('
            s += ',\n    '.join(['.' + p.name.ljust(max_len) +' (' + str(p.value) + ')' for p in self.parameters])
            s += ')\n'
        s += ' ' + self.name

        if self.ports:
            s += '\n   ('
            max_len = max([len(p.name) for p in self.ports])
            s += ',\n    '.join(['.' + p.name.ljust(max_len) +' (' + str(p.value) + ')' for p in self.ports])
            s += ')'
        s += ';\n'
        return s

class VerilogWriter:
    raw = ""
    def __init__(self, name):
        self.name = name
        self.instances = []
        self.ports = []
        self.wires = []

    def add(self, obj):
        if isinstance(obj, Instance):
            self.instances += [obj]
        elif isinstance(obj, ModulePort):
            self.ports += [obj]
        elif isinstance(obj, Wire):
            self.wires += [obj]
        else:
            raise Exception("Invalid type!" + str(obj))

    def write(self, file=None):
        s = ("// THIS FILE IS AUTOGENERATED BY axi_intercon_gen\n"
             "// ANY MANUAL CHANGES WILL BE LOST\n")
        if self.ports:
            s += "`default_nettype none\n"
            s += "module {name}\n".format(name=self.name)
            max_len = max([len(p.range()) for p in self.ports])
            s += '   ('
            s += ',\n    '.join([p.write(max_len) for p in self.ports])
            s += ')'
            s += ';\n\n'
        if self.wires:
            max_len = max([len(w.range()) for w in self.wires])
            for w in self.wires:
                s += w.write(max_len + 1)
            s +='\n'
        s += self.raw
        for i in self.instances:
            s += i.write()
            s += '\n'
        if self.ports:
            s += 'endmodule\n'
        if file is None:
            return s
        else:
            f = open(file,'w')
            f.write(s)
