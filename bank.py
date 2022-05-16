class Bank:
    bank_name = 'New delhi' #class variable
    def __init__(self,name,balance,act,amt,bank=bank_name): #bank=bank_name class variable assigned to instance as default
      
    #when __init__ is not used then uncomment the below commented lines    
    # def set_details (self,name,balance,act,amt):
        self.name= name
        self.balance= balance
        self.act= act
        self.amt = amt
        self.bank = bank
        
        print('\nCustomer details \n Name::', self.name, '\n Balance::',self.balance,Bank.bank_name )
        if self.act == 'withdraw':
            self.withdraw()
        elif self.act == 'deposit':            
            self.deposit()
        else:
            print ('No action performed')
        self.display()
    
    def display (self):
        print(' After',self.act, 'Balance is',self.balance)
           
    def withdraw (self):
        self.balance-= self.amt
        return self.amt
            
    def deposit (self):
        self.balance+= self.amt
        return self.amt
    
#cust1 = Bank()
#cust2 = Bank()
#cust1.set_details('Sam',10000,'withdraw',4000)
#cust2.set_details('Alex',12500,'deposit',2500)
cust1 = Bank('Sam',10000,'withdraw',4000)
cust2 = Bank('Alex',12500,'deposit',2500)   