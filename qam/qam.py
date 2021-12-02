import socket, pickle

HOST = '127.0.0.1'
PORT = 2000

min = 1
max = 3


# converts text to its binary presentation (8 bits)
def textToBinary(text, hamming=True):
	# return ''.join(format(ord(x), '08b') for x in text)
	bin = ''.join(format(ord(x), '08b') for x in text)
	if hamming:
		print('og:',bin)
		fin = ''
		for i in range(0, len(bin), 8):
			b = bin[i:i+8]
			b = list(map(int, b[:4] + '0' + b[4:7] + '0' + b[7:8] + '00'))
			r1 = (b[11] + b[9] + b[7] + b[5] + b[3] + b[1]) % 2
			b[11] = r1
			r2 = (b[10] + b[9] + b[6] + b[5] + b[2] + b[1]) % 2
			b[10] = r2
			r4 = (b[8] + b[7] + b[6] + b[5] + b[0]) % 2
			b[8] = r4
			r8 = (b[4] + b[3] + b[2] + b[1] + b[0]) % 2
			b[4] = r8
			fin += ''.join(map(str, b))
		return fin
	else:
		return bin



# convert bits to I and Q using 16qam
def qam16(bits):
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
	i, q = convert[bits]
	if i >= 0:
		print(str(q) + '+' + str(i)+'i', end=' ')
	else:
		print(str(q) + '-' + str(-i)+'i', end=' ')
	# return (i, q)
	return complex(q,i)

def qam4(bits):
	nr = int(bits, 2)
	q = nr // 2
	i = nr % 2
	convert = dict({
		0: -1,
		1: 1})
	i = convert[i]
	q = -convert[q] * i
	return (i, q)



# converts text to an array of I and Q values
def getIqValues(text):
	b = textToBinary(text)
	print(b)
	t = []
	for i in range(0, len(b), 4):
		t.append(qam16(b[i:i+4]))
	return t

def getIq4Values(text):
	b = textToBinary(text)
	t = []
	for i in range(0, len(b), 2):
		t.append(qam4(b[i:i+2]))
	return t


if (__name__ == "__main__" and False):
	while (True):
		try:
			ip = input('text: ')
		except KeyboardInterrupt:
			print()
			break
		else:
			v = getIqValues(ip)
			print()
			print(v)



with socket.socket(socket.AF_INET, socket.SOCK_STREAM) as s:
	s.connect((HOST, PORT))
	while(True):
		s.sendall(b'-1+3i')
		s.sendall(b'-1-3i')
		s.sendall(b'1-3i')
		s.sendall(b'1+3i')
	data = s.recv(1024)

print('Received', repr(data))