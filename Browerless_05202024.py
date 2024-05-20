from selenium import webdriver
from selenium.webdriver.chrome.service import Service
from selenium.webdriver.common.by import By
from selenium.webdriver.chrome.options import Options

# Setup Chrome options
options = Options()
options.add_argument('--headless')
options.add_argument('--disable-gpu')
options.add_argument('--no-sandbox')

# Setup Chrome driver service
service = Service(executable_path="/opt/webdriver/chromedriver")

# Initialize Chrome driver with service and options
driver = webdriver.Chrome(service=service, options=options)

# Navigate to a web page
driver.get("https://www.google.com")

# Find the search bar element
search_bar = driver.find_element(By.NAME, "q")

# Enter a search term
search_bar.send_keys("Python Selenium")

# Click the search button
search_bar.submit()

# Wait for results to load and get the page title
driver.implicitly_wait(10)
page_title = driver.title

# Print the page title
print(page_title)

# Close the Selenium browser session
driver.quit()
