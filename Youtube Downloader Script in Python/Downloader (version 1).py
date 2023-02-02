import pandas
import time
from selenium import webdriver
from selenium.webdriver.common.by import By	
from selenium.webdriver.support.ui import WebDriverWait		
from selenium.webdriver.support import expected_conditions as ec
from bs4 import BeautifulSoup
import requests

excel = r'...\credenciales.xlsx'

df = pandas.read_excel(excel, sheet_name='Hoja1')

user = str(df['usuario'][1])
psw = df ['contraseña'][1]

link = input("Pegue el link de youtube a descargar: ")
print("""Opciones de descarga:
1. Descargar vídeo
2. Descargar únicamente el sonido """)

seleccion = int(input("Escriba el número de la opción deseada: "))

if seleccion == 1:

    url = 'https://es.savefrom.net/1-youtube-video-downloader-88.html'

    busqueda = '/html/body/div[1]/div[1]/div[1]/div/div[1]/div[2]/div/form/div[1]/div/input'

    selector_boton = '/html/body/div[1]/div[1]/div[1]/div/div[1]/div[2]/div/form/div[2]/button'

    boton_descarga = '/html/body/div[1]/div[1]/div[2]/div[4]/div/div[1]/div[2]/div[2]/div[1]/a'


    #para abrir navegador

    driver = webdriver.Chrome()
    driver.maximize_window() #maximizar pantallla

    #abrir pagina:

    driver.get(url)

    #acciones de pagina

    driver.find_element_by_xpath(busqueda).click()
    wait = WebDriverWait(driver,6)
    wait.until(ec.visibility_of_element_located((By.XPATH, busqueda)))
    driver.find_element_by_xpath(busqueda).send_keys(link)
    driver.find_element_by_xpath(selector_boton).click() # da click en selector_boton
    wait = WebDriverWait(driver,6)
    wait.until(ec.visibility_of_element_located((By.XPATH, boton_descarga)))
    driver.find_element_by_xpath(boton_descarga).click() # da click en selector_boton

    time.sleep(240)

elif seleccion == 2:

    url = "https://www.y2mate.com/es266/youtube-mp3"

    busqueda = '/html/body/div[1]/div[1]/div/div/div[1]/div/div/div/div[2]/form/input'

    selector_boton = '/html/body/div[1]/div[1]/div/div/div[1]/div/div/div/div[2]/form/button/span[1]'

    boton_descarga = '/html/body/div[1]/div[1]/div/div/div[1]/div/div/div/div[4]/div/div[2]/div/div/div[2]/button[1]'

    boton_descarga_final = '/html/body/div[1]/div[2]/div[2]/div/div[2]/div[2]/div/a'


    #para abrir navegador

    driver = webdriver.Chrome()
    driver.maximize_window() #maximizar pantallla

    #abrir pagina:

    driver.get(url)

    #acciones de pagina

    driver.find_element_by_xpath(busqueda).click()
    wait = WebDriverWait(driver,3)
    wait.until(ec.visibility_of_element_located((By.XPATH, busqueda)))
    driver.find_element_by_xpath(busqueda).send_keys(link)
    driver.find_element_by_xpath(selector_boton).click() # da click en selector_boton
    wait = WebDriverWait(driver,3)
    wait.until(ec.visibility_of_element_located((By.XPATH, boton_descarga)))
    driver.find_element_by_xpath(boton_descarga).click() # da click en selector_boton
    wait = WebDriverWait(driver,3)
    wait.until(ec.visibility_of_element_located((By.XPATH, boton_descarga_final)))
    driver.find_element_by_xpath(boton_descarga_final).click()


    time.sleep(240)

else:
    input("Opción incorrecta. Ingrese los datos de nuevo")
