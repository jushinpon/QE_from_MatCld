#https://googlechromelabs.github.io/chrome-for-testing/#stable

#wget https://dl.google.com/linux/linux_signing_key.pub
#rpm --import linux_signing_key.pub
#wget https://dl.google.com/linux/direct/google-chrome-stable_current_x86_64.rpm
# dnf localinstall google-chrome-stable_current_x86_64.rpm

#google-chrome-stable --no-sandbox --headless --disable-gpu --screenshot https://www.baidu.com
#google-chrome-stable --version
#download webdriver with the same version with google-chrome-stable (ls /opt/webdriver)

#For all user
#mkdir -p /tmp/Crashpad
#chmod -R 777 /tmp/Crashpad/


from selenium import webdriver
#from selenium.webdriver import Chrome
#options = webdriver.ChromeOptions()
#options.headless = True

options = webdriver.ChromeOptions()
options.add_argument('--headless')
options.add_argument('--disable-gpu')
#options.add_argument('--no-sandbox')
driver = webdriver.Chrome(executable_path="/opt/webdriver/chromedriver", options=options)

# Navigate to a web page
driver.get("https://www.google.com")

# Find the search bar element
search_bar = driver.find_element_by_name("q")

# Enter a search term
search_bar.send_keys("Python Selenium")

# Click the search button
search_bar.submit()

# Get the page title
page_title = driver.title

# Print the page title
print(page_title)

# Close the Selenium browserless session
driver.quit()