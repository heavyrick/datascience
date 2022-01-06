import time

print('Tabuada')
numero_digitado = input('Digite o número da tabuada que deseja calcular: ')

print('Vamos calcular a tabuada do ' + numero_digitado + '\n')
time.sleep(2)

i = 0
while i < 11:
    total = int(numero_digitado) * i
    print('{} x {} = {}'.format(numero_digitado, i, total))
    i += 1
    
print("\n")