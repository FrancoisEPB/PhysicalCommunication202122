"""
Embedded Python Blocks:

Each time this file is saved, GRC will instantiate the first class it finds
to get ports and parameters of your block. The arguments to __init__  will
be the parameters. All of them are required to have default values!
"""

import numpy as np
from gnuradio import gr


class qam16Block(gr.sync_block):
    def __init__(self):
        gr.sync_block.__init__(
            self,
            name='qam16',
            in_sig=[np.uint32],
            out_sig=[np.complex64]
        )

    def work(self, input_items, output_items):
        mijnString = str(input_items[0])
        bits = "11100101110010" + ''.join(format(ord(x), '08b') for x in mijnString) + "00"

        min = 0.3535
        max = 0.707

        t = []
        for i in range(0, len(bits), 4):
            convert = dict({
                '0000': (-max, -max),
                '0001': (-min, -max),
                '0010': (max, -max),
                '0011': (min, -max),
                '0100': (-max, -min),
                '0101': (-min, -min),
                '0110': (max, -min),
                '0111': (min, -min),
                '1000': (-max, max),
                '1001': (-min, max),
                '1010': (max, max),
                '1011': (min, max),
                '1100': (-max, min),
                '1101': (-min, min),
                '1110': (max, min),
                '1111': (min, min),
            })
            i, q = convert[bits[i:i+4]]
            t.append(complex(q,i))

        # output_items[0][0] = complex(q,i)
        #print(len(input_items[0]), len(output_items[0]), len(t))
        output_items[0][0:len(t)] = t

        return len(output_items[0])

        #[0.707+0.707j,  0.3535+0.707j, 0.3535+0.3535j, 0.707+0.3535j, -0.3535+0.707j, -0.707+0.707j, -0.707+0.3535j, -0.3535+0.3535j, -0.3535-0.3535j, -0.707-0.3535j, -0.707-0.707j, -0.3535-0.707j, 0.707-0.3535j, 0.3535-0.3535j, 0.3535-0.707j, 0.707-0.707j]