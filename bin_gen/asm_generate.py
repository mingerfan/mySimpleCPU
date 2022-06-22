import re

RAM_Size = 0xFFFF
RAM_width = 32

# noinspection DuplicatedCode
seg_dict = dict()

# noinspection DuplicatedCode
reg = [0] * 32
reg_map = [''] * 32
for i in range(0, 32):
    reg[i] = 0
    reg_map[i] = bin(i)
    reg_map[i] = reg_map[i].replace('0b', '')
    reg_map[i] = reg_map[i].rjust(5, '0')

print("map:", reg_map)

R_OP = "0110011"
I_OP = "0000011"
S_OP = "0100011"
J_OP = "1101111"
IMM_OP = "0010011"
LUI_OP = "0110111"

func7_ = (0, 7)
func3_ = (17, 20)
rs1_ = (12, 17)
rs2_ = (7, 12)
rd_ = (20, 25)

ADD_func3 = "000"
ADD_func7 = "0000000"

SUB_func3 = "000"
SUB_func7 = "0100000"

ADDI_func3 = "000"

LW_func3 = "010"

SW_func3 = "010"

total_dict = dict()


def list_write(list_: list, start: int, end: int, string: str, st_start: int = 0):
    for item in range(start, end):
        list_[item] = string[item - start + st_start]
    return list_


class AsmBase:
    def __init__(self):
        self.segment = ''
        self.j_segment = ''
        self.asm_ins = ''
        self.code = ['0'] * 32
        self.seg_index = 0x00000000
        self.rs1 = None
        self.rs2 = None
        self.rd1 = None
        self.im = None

    def set_data(self):
        if self.asm_ins == 'ADD':
            self.code = list_write(self.code, 25, 32, R_OP)
            self.code = list_write(self.code, rd_[0], rd_[1], reg_map[self.rd1])
            self.code = list_write(self.code, func3_[0], func3_[1], ADD_func3)
            self.code = list_write(self.code, rs1_[0], rs1_[1], reg_map[self.rs1])
            self.code = list_write(self.code, rs2_[0], rs2_[1], reg_map[self.rs2])
            self.code = list_write(self.code, func7_[0], func7_[1], ADD_func7)
        elif self.asm_ins == "SUB":
            self.code = list_write(self.code, rd_[0], rd_[1], reg_map[self.rd1])
            self.code = list_write(self.code, 25, 32, R_OP)
            self.code = list_write(self.code, func3_[0], func3_[1], SUB_func3)
            self.code = list_write(self.code, rs1_[0], rs1_[1], reg_map[self.rs1])
            self.code = list_write(self.code, rs2_[0], rs2_[1], reg_map[self.rs2])
            self.code = list_write(self.code, func7_[0], func7_[1], SUB_func7)
        elif self.asm_ins == "LUI":
            self.code = list_write(self.code, 25, 32, LUI_OP)
            self.code = list_write(self.code, rd_[0], rd_[1], reg_map[self.rd1])
            self.code = list_write(self.code, 0, 20, self.im)
        elif self.asm_ins == "ADDI":
            self.code = list_write(self.code, 25, 32, IMM_OP)
            self.code = list_write(self.code, rd_[0], rd_[1], reg_map[self.rd1])
            self.code = list_write(self.code, func3_[0], func3_[1], ADDI_func3)
            self.code = list_write(self.code, rs1_[0], rs1_[1], reg_map[self.rs1])
            self.code = list_write(self.code, 0, 12, self.im, 0)
        elif self.asm_ins == "LW":
            self.code = list_write(self.code, 25, 32, I_OP)
            self.code = list_write(self.code, rd_[0], rd_[1], reg_map[self.rd1])
            self.code = list_write(self.code, func3_[0], func3_[1], LW_func3)
            self.code = list_write(self.code, rs1_[0], rs1_[1], reg_map[self.rs1])
            self.code = list_write(self.code, 0, 12, self.im, 0)
        elif self.asm_ins == "SW":
            self.code = list_write(self.code, 25, 32, S_OP)
            self.code = list_write(self.code, 20, 25, self.im, 7)
            self.code = list_write(self.code, func3_[0], func3_[1], SW_func3)
            self.code = list_write(self.code, rs1_[0], rs1_[1], reg_map[self.rs1])
            self.code = list_write(self.code, rs2_[0], rs2_[1], reg_map[self.rs2])
            self.code = list_write(self.code, 0, 7, self.im, 0)

    def write_jal(self):
        self.code = list_write(self.code, 25, 32, J_OP)
        self.code = list_write(self.code, rd_[0], rd_[1], reg_map[self.rd1])
        self.code = list_write(self.code, 12, 20, self.im, 1)
        self.code = list_write(self.code, 11, 12, self.im, 9)
        self.code = list_write(self.code, 1, 11, self.im, 10)
        self.code = list_write(self.code, 0, 1, self.im, 0)


asm_file = open(r".\asm.txt", mode="r")


def rmv_empty(list_out: list):
    for index, item in enumerate(list_out):
        if item == '':
            del list_out[index]


def bec_int(string: str):
    res = string.replace("x", "")
    return int(res)


def to_bin(string: str, length: int = 32, base: int = 10):
    bin_in = int(string, base)
    bin_str = bin(bin_in)
    bin_str = bin_str.replace('0b', '')
    bin_str = bin_str.rjust(length, '0')
    return bin_str


def offset(string: str, length: int = 32):
    res_ = re.split("[()]", string)
    rmv_empty(res_)
    res_[0] = to_bin(res_[0], length)
    res_[1] = bec_int(res_[1])
    return res_


def tr_addr16_bin(addr_in: int, begin: int, end: int):
    res_ = bin(addr_in)
    string = ''
    res_ = res_.replace('0b', '')
    res_ = res_.rjust(32, '0')
    for index in range(len(res_)-end, len(res_)-begin):
        string += res_[index]
    print(len(string))
    return string


cur_seg = None
seg_index = 0
PC_cnt = 0x00000000

try:
    while True:
        line = asm_file.readline()
        if line == '':
            break
        if ':' in line:
            seg_list = line.split(':')
            cur_seg = seg_list[0]
            seg_dict[cur_seg] = PC_cnt*4
            seg_index = 0
        elif line != '\n':
            asm_ = AsmBase()
            str_list = re.split("[,\\s ]", line)
            rmv_empty(str_list)
            asm_.segment = cur_seg
            asm_.seg_index = seg_index
            seg_index += 1
            if str_list[0] == "add":
                asm_.asm_ins = "ADD"
                asm_.rd1 = bec_int(str_list[1])
                asm_.rs1 = bec_int(str_list[2])
                asm_.rs2 = bec_int(str_list[3])
            elif str_list[0] == "sub":
                asm_.asm_ins = "SUB"
                asm_.rd1 = bec_int(str_list[1])
                asm_.rs1 = bec_int(str_list[2])
                asm_.rs2 = bec_int(str_list[3])
            elif str_list[0] == "addi":
                asm_.asm_ins = "ADDI"
                asm_.rd1 = bec_int(str_list[1])
                asm_.rs1 = bec_int(str_list[2])
                asm_.im = to_bin(str_list[3], 12)
            elif str_list[0] == "lui":
                asm_.asm_ins = "LUI"
                asm_.rd1 = bec_int(str_list[1])
                if '0x' in str_list[2]:
                    asm_.im = to_bin(str_list[2], 20, 16)
                else:
                    asm_.im = to_bin(str_list[2], 20)
            elif str_list[0] == "lw":
                asm_.asm_ins = "LW"
                asm_.rd1 = bec_int(str_list[1])
                result = offset(str_list[2], 12)
                asm_.rs1 = result[1]
                asm_.im = result[0]
            elif str_list[0] == "sw":
                asm_.asm_ins = "SW"
                asm_.rs2 = bec_int(str_list[1])
                result = offset(str_list[2], 12)
                asm_.rs1 = result[1]
                asm_.im = result[0]
            elif str_list[0] == 'jal':
                asm_.asm_ins = "JAL"
                asm_.rd1 = bec_int(str_list[1])
                asm_.j_segment = str_list[2]
            else:
                continue
            asm_.set_data()
            total_dict[PC_cnt] = asm_
            PC_cnt += 1

except EOFError:
    pass

file = open(r".\bin.txt", mode="w")
file.write("MEMORY_INITIALIZATION_RADIX=2;\n")
file.write("MEMORY_INITIALIZATION_VECTOR=\n")
for i in range(0, int(RAM_Size/RAM_width*4) - 1):
    if i in total_dict.keys():
        if total_dict[i].asm_ins == "JAL":
            total_dict[i].im = tr_addr16_bin(seg_dict[total_dict[i].j_segment], 0, 21)
            total_dict[i].write_jal()
        file.write(''.join(total_dict[i].code) + ',\n')
    else:
        file.write('00000000000000000000000000000000' + ',\n')

file.write('00000000000000000000000000000000' + ';')
