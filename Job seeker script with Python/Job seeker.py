import pandas
import time
import os
from selenium import webdriver
from selenium.webdriver.common.by import By	#acceder a un subpaquete más rápidamente
from selenium.webdriver.support.ui import WebDriverWait		#esperar respuesta
from selenium.webdriver.support import expected_conditions as ec
from bs4 import BeautifulSoup
import requests

excel = r'C:\Users\aalex\Documents\EXCEL CR\credenciales.xlsx'

df = pandas.read_excel(excel, sheet_name='Hoja1')

user = str(df['usuario'][1])
psw = df ['contraseña'][1]

resultado1 = 0
resultado2 = 0

url = 'https://encuentraempleo.trabajo.gob.ec/socioEmpleo-war/paginas/index.jsf'

boton1 = '/html/body/div[1]/div[2]/div[1]/div[1]/div[2]/div/div/a/img'
selector_usuario = '/html/body/div[1]/div[2]/div[1]/div[7]/div[2]/div/div/div/form/div[1]/input'
selector_pass = '/html/body/div[1]/div[2]/div[1]/div[7]/div[2]/div/div/div/form/div[2]/input'
selector_boton = '/html/body/div[1]/div[2]/div[1]/div[7]/div[2]/div/div/div/form/div[3]/a[1]'

ocasional = '/html/body/div[1]/div[5]/form[1]/div[1]/div[3]/a/table/tbody/tr/td[2]/img'

filtrar = '/html/body/div[1]/div[5]/form[1]/div/ul/li/a/img'
cargo = '/html/body/div[1]/div[5]/form[2]/div/div[2]/center/div/table/tbody/tr[2]/td[2]/input'
buscar = '/html/body/div[1]/div[5]/form[2]/div/div[2]/center/div/table/tbody/tr[11]/td[2]/a/img'

#para abrir navegador

driver = webdriver.Chrome()
driver.maximize_window() #maximizar pantallla

#abrir pagina:

driver.get(url)

#acciones de pagina

driver.find_element_by_xpath(boton1).click()
wait = WebDriverWait(driver,3)
wait.until(ec.visibility_of_element_located((By.XPATH, selector_usuario)))
driver.find_element_by_xpath(selector_usuario).send_keys('1721255295')
driver.find_element_by_xpath(selector_pass).send_keys(psw)
driver.find_element_by_xpath(selector_boton).click() # da click en selector_boton
wait = WebDriverWait(driver,3)
wait.until(ec.visibility_of_element_located((By.XPATH, ocasional)))
driver.find_element_by_xpath(ocasional).click() # da click en selector_boton
wait = WebDriverWait(driver,3)
wait.until(ec.visibility_of_element_located((By.XPATH, filtrar)))
driver.find_element_by_xpath(filtrar).click() # da click en selector_boton

os.system('cls')
for i in df.index:

    puesto = df ['puesto'][i]
    wait = WebDriverWait(driver,3)
    wait.until(ec.visibility_of_element_located((By.XPATH, cargo)))
    driver.find_element_by_xpath(cargo).clear()
    driver.find_element_by_xpath(cargo).send_keys(puesto)
    driver.find_element_by_xpath(buscar).click()
    time.sleep(2)
    print(f'                        PUESTO: {puesto}')
    soup = BeautifulSoup(driver.page_source, 'html.parser')

    et = soup.find_all('td') #.get_span es la etiqueta y class la clase en inspeccionarelemento

    info = list()

    for i in et:
        info.append(i.text)

    for i in range(len(info)):


        if '0 DIAS' in info[i]:

            print(f'''

            OFERTAS DE HOY: {info[i]}''')
            print('*'*50)
            resultado1 += 1


        elif '1 DIAS' in info[i]:
            print(f'''

            OFERTAS DE AYER: {info[i]}
            ''')
            print('*'*50)
            resultado2 += 1


        else:
            pass


    driver.find_element_by_xpath(filtrar).click() # da click en selector_boton
print(f'COINCIDENCIAS HOY: {int(resultado1 / 2)}')
print(f'COINCIDENCIAS AYER: {int(resultado2 / 2)}')

input('Enter para salir')
