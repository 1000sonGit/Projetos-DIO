menu = """

    [d] Depositar
    [s] Sacar
    [e] Extrato
    [q] Sair

=> """

saldo = 0
limite = 500
extrato = []
numero_saques = 0
LIMITE_SAQUES = 3
total = 0.0

while True:

    opcao = input(menu)

    if opcao == 'd':
        print("Depósito")
        while True:
            try:
                deposito = float(input("Digite o valor desejado: "))
                total += deposito
                break
            except ValueError:
                print("Opss! Esse valor é inválido. Tente  novamente")

        extrato.append(deposito)

    elif opcao == 's' and numero_saques <= LIMITE_SAQUES:
        print("Saque")
        while True:
            try:
                saque = float(input("Digite o valor desejado: "))

                if saque > limite or (total-saque) < 0:
                    raise NameError
                break
            except ValueError:
                print(f"Opss! Esse valor é inválido. Tente  novamente.")

            except NameError:
                print(f"OBS: A quantidade limite de saques diários é de {limite} e você\n"
                      f"não pode negativar sua conta.")

        extrato.append(saque*-1)
        total -= saque
        numero_saques += 1

    elif opcao == 'e':
        print("Extrato")
        for i in range(len(extrato)):
            print(f'R${extrato[i]:.2f}')
        if len(extrato) != 0:
            print(f'Saldo: {total:.2f}')
        else:
            print('Não foram realizadas movimentações')

    elif opcao == 'q':
        break

    else:
        print("Operação inválida, por favor selecione novamente a operação desejada.")
