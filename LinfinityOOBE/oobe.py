import gi
from subprocess import Popen
gi.require_version('Gtk', '3.0')
from gi.repository import Gtk, Pango, GdkPixbuf
import os

abspath = os.path.abspath(__file__)
dname = os.path.dirname(abspath)
os.chdir(dname)

class OOBE:
    def __init__(self) -> None:
        self.win = Gtk.Window()
        self.win.fullscreen()
        self.page_index = 0
        self.pages = [self.first_page, self.second_page, self.third_page, self.fourth_page, self.fifth_page, self.sixth_page, self.seventh_page, self.eighth_page, self.ninth_page]
        self.pages[self.page_index]()
        self.win.connect("destroy", Gtk.main_quit)
        self.win.show_all()
        Gtk.main()

    def first_page(self):
        pageBox = Gtk.Box(orientation=Gtk.Orientation.HORIZONTAL, spacing=1)
        pageContainerBox = Gtk.Box(
            orientation=Gtk.Orientation.VERTICAL, spacing=1)
        logoBox = Gtk.Box(orientation=Gtk.Orientation.VERTICAL, spacing=0)
        logoBox.hexpand = False
        logo = Gtk.Image.new_from_pixbuf(
            GdkPixbuf.Pixbuf.new_from_file_at_scale("logo.png", 200, 200, False))
        logoBox.pack_start(logo, True, True, 10)
        welcomeLabel = Gtk.Label()
        welcomeLabel.set_markup('<span size="42000"><b>Welcome</b></span>')
        logoBox.pack_start(welcomeLabel, True, True, 5)
        labelNext = Gtk.Label()
        labelNext.set_markup('<span size="14000">to Linfinity Linux</span>')
        logoBox.pack_start(labelNext, True, True, 0)
        startButton = Gtk.Button(label="Let's begin!")
        for child in startButton.get_children():
            child.set_label('<span size="16000">Let\'s begin!</span>')
            child.set_use_markup(True)
        startButton.set_property("height_request", 75)
        startButton.connect("clicked", self.advance)
        logoBox.pack_start(startButton, True, True, 75)
        pageContainerBox.pack_start(logoBox, True, False, 10)
        pageBox.pack_start(pageContainerBox, True, False, 0)
        self.win.add(pageBox)
        self.page_element = pageBox

    def second_page(self):
        pageBox = Gtk.Box(orientation=Gtk.Orientation.HORIZONTAL, spacing=1)
        pageContainerBox = Gtk.Box(
            orientation=Gtk.Orientation.VERTICAL, spacing=1)
        logoBox = Gtk.Box(orientation=Gtk.Orientation.VERTICAL, spacing=0)
        logoBox.hexpand = False
        logo = Gtk.Image.new_from_pixbuf(
            GdkPixbuf.Pixbuf.new_from_file_at_scale("logo.png", 200, 200, False))
        logoBox.pack_start(logo, True, True, 10)
        welcomeLabel = Gtk.Label()
        welcomeLabel.set_markup('<span size="42000"><b>Connect</b></span>')
        logoBox.pack_start(welcomeLabel, True, True, 5)
        labelNext = Gtk.Label()
        labelNext.set_markup('<span size="14000">to the Internet</span>')
        logoBox.pack_start(labelNext, True, True, 0)
        connectionButtonBox = Gtk.Box(
            orientation=Gtk.Orientation.HORIZONTAL, spacing=1)
        wifiIcon = Gtk.Image()
        wifiIcon.set_from_icon_name("network-wireless", Gtk.IconSize.DIALOG)
        wifiButton = Gtk.Button(image=wifiIcon)
        wifiButton.set_property("height_request", 80)
        wifiButton.set_property("width_request", 80)
        wifiButton.connect("clicked", self.wifi_settings)
        connectionButtonBox.pack_start(wifiButton, True, True, 10)
        ethIcon = Gtk.Image()
        ethIcon.set_from_icon_name("network-wired", Gtk.IconSize.DIALOG)
        ethButton = Gtk.Button(image=ethIcon)
        ethButton.set_property("height_request", 80)
        ethButton.set_property("width_request", 80)
        ethButton.connect("clicked", self.eth_settings)
        connectionButtonBox.pack_start(ethButton, True, True, 10)
        logoBox.pack_start(connectionButtonBox, True, True, 50)
        nextButton = Gtk.Button(label="Next")
        for child in nextButton.get_children():
            child.set_label('<span size="16000">NEXT</span>')
            child.set_use_markup(True)
        nextButton.set_property("height_request", 75)
        nextButton.set_property("width_request", 120)
        nextButton.connect("clicked", self.advance)
        backIcon = Gtk.Image()
        backIcon.set_from_icon_name("go-previous", Gtk.IconSize.DIALOG)
        backButton = Gtk.Button(image=backIcon)
        backButton.set_property("height_request", 75)
        backButton.set_property("width_request", 75)
        backButton.connect("clicked", self.disadvance)
        backNextContainer = Gtk.Box(
            orientation=Gtk.Orientation.HORIZONTAL, spacing=1)
        backNextContainer.pack_start(backButton, True, False, 1)
        backNextContainer.pack_start(nextButton, True, True, 1)
        logoBox.pack_start(backNextContainer, True, True, 25)
        pageContainerBox.pack_start(logoBox, True, False, 10)
        pageBox.pack_start(pageContainerBox, True, False, 0)
        self.win.add(pageBox)
        self.page_element = pageBox

    def third_page(self):
        pageBox = Gtk.Box(orientation=Gtk.Orientation.HORIZONTAL, spacing=1)
        pageContainerBox = Gtk.Box(
            orientation=Gtk.Orientation.VERTICAL, spacing=1)
        logoBox = Gtk.Box(orientation=Gtk.Orientation.VERTICAL, spacing=0)
        logoBox.hexpand = False
        logo = Gtk.Image.new_from_pixbuf(
            GdkPixbuf.Pixbuf.new_from_file_at_scale("logo.png", 200, 200, False))
        logoBox.pack_start(logo, True, True, 10)
        welcomeLabel = Gtk.Label()
        welcomeLabel.set_markup('<span size="42000"><b>Sign in</b></span>')
        logoBox.pack_start(welcomeLabel, True, True, 5)
        labelNext = Gtk.Label()
        labelNext.set_markup(
            '<span size="14000">Create a new user account</span>')
        logoBox.pack_start(labelNext, True, True, 0)
        userBox = Gtk.Box(orientation=Gtk.Orientation.VERTICAL, spacing=1)
        self.usernameEntry = Gtk.Entry()
        self.usernameEntry.set_placeholder_text("username")
        self.usernameEntry.set_size_request(100, 40)
        self.usernameEntry.modify_font(Pango.FontDescription('Inter 16'))
        self.passwordEntry = Gtk.Entry()
        self.passwordEntry.set_placeholder_text("password")
        self.passwordEntry.set_visibility(False)
        self.passwordEntry.set_size_request(100, 40)
        self.passwordEntry.modify_font(Pango.FontDescription('Inter 16'))
        self.cPasswordEntry = Gtk.Entry()
        self.cPasswordEntry.set_placeholder_text("confirm password")
        self.cPasswordEntry.set_visibility(False)
        self.cPasswordEntry.set_size_request(100, 40)
        self.cPasswordEntry.modify_font(Pango.FontDescription('Inter 16'))
        userBox.pack_start(self.usernameEntry, True, True, 5)
        userBox.pack_start(self.passwordEntry, True, True, 5)
        userBox.pack_start(self.cPasswordEntry, True, True, 5)
        logoBox.pack_start(userBox, True, True, 50)
        nextButton = Gtk.Button(label="Next")
        for child in nextButton.get_children():
            child.set_label('<span size="16000">NEXT</span>')
            child.set_use_markup(True)
        nextButton.set_property("height_request", 75)
        nextButton.set_property("width_request", 120)
        nextButton.connect("clicked", self.passwd)
        backIcon = Gtk.Image()
        backIcon.set_from_icon_name("go-previous", Gtk.IconSize.DIALOG)
        backButton = Gtk.Button(image=backIcon)
        backButton.set_property("height_request", 75)
        backButton.set_property("width_request", 75)
        backButton.connect("clicked", self.disadvance)
        backNextContainer = Gtk.Box(
            orientation=Gtk.Orientation.HORIZONTAL, spacing=1)
        backNextContainer.pack_start(backButton, True, False, 1)
        backNextContainer.pack_start(nextButton, True, True, 1)
        logoBox.pack_start(backNextContainer, True, True, 25)
        pageContainerBox.pack_start(logoBox, True, False, 10)
        pageBox.pack_start(pageContainerBox, True, False, 0)
        self.win.add(pageBox)
        self.page_element = pageBox
    
    def fourth_page(self):
        pageBox = Gtk.Box(orientation=Gtk.Orientation.HORIZONTAL, spacing=1)
        pageContainerBox = Gtk.Box(orientation=Gtk.Orientation.VERTICAL, spacing=1)
        logoBox = Gtk.Box(orientation=Gtk.Orientation.VERTICAL, spacing=0)
        logoBox.hexpand = False
        logo = Gtk.Image.new_from_pixbuf(
            GdkPixbuf.Pixbuf.new_from_file_at_scale("logo.png", 200, 200, False))
        logoBox.pack_start(logo, True, True, 10)
        welcomeLabel = Gtk.Label()
        welcomeLabel.set_markup('<span size="42000"><b>Additional settings</b></span>')
        logoBox.pack_start(welcomeLabel, True, True, 5)
        buttonsBox = Gtk.Box(orientation=Gtk.Orientation.VERTICAL, spacing=1)
        dateButton = Gtk.Button(label="Date")
        for child in dateButton.get_children():
            child.set_label('<span size="16000">Date &amp; time</span>')
            child.set_use_markup(True)
        dateButton.set_property("height_request", 50)
        dateButton.connect("clicked", self.datetime)
        buttonsBox.pack_start(dateButton, True, True, 1)
        regionButton = Gtk.Button(label="Region")
        for child in regionButton.get_children():
            child.set_label('<span size="16000">Region &amp; language</span>')
            child.set_use_markup(True)
        regionButton.set_property("height_request", 50)
        regionButton.connect("clicked", self.region)
        buttonsBox.pack_start(regionButton, True, True, 1)
        logoBox.pack_start(buttonsBox, True, False, 25)
        startButton = Gtk.Button(label="Next")
        for child in startButton.get_children():
            child.set_label('<span size="16000">NEXT</span>')
            child.set_use_markup(True)
        startButton.set_property("height_request", 75)
        startButton.connect("clicked", self.advance)
        logoBox.pack_start(startButton, True, True, 50)
        pageContainerBox.pack_start(logoBox, True, False, 10)
        pageBox.pack_start(pageContainerBox, True, False, 0)
        self.win.add(pageBox)
        self.page_element = pageBox
    
    def fifth_page(self):
        pageBox = Gtk.Box(orientation=Gtk.Orientation.HORIZONTAL, spacing=1)
        os.system("gnome-control-center online-accounts")
        self.win.add(pageBox)
        self.page_element = pageBox
        self.advance(self)
    
    def sixth_page(self):
        pageBox = Gtk.Box(orientation=Gtk.Orientation.HORIZONTAL, spacing=1)
        pageContainerBox = Gtk.Box(orientation=Gtk.Orientation.VERTICAL, spacing=1)
        logoBox = Gtk.Box(orientation=Gtk.Orientation.VERTICAL, spacing=0)
        logoBox.hexpand = False
        welcomeLabel = Gtk.Label()
        welcomeLabel.set_markup('<span size="42000"><b>Linfinity recommends</b></span>')
        logoBox.pack_start(welcomeLabel, True, True, 5)
        appLogo = Gtk.Image.new_from_pixbuf(GdkPixbuf.Pixbuf.new_from_file_at_scale("firefox.png", 200, 200, False))
        logoBox.pack_start(appLogo, True, True, 50)
        labelNext = Gtk.Label()
        labelNext.set_markup('<span size="16000">Surf the web using Firefox, the free and open source web browser!</span>')
        logoBox.pack_start(labelNext, True, True, 10)
        startButton = Gtk.Button(label="Next")
        for child in startButton.get_children():
            child.set_label('<span size="16000">NEXT</span>')
            child.set_use_markup(True)
        startButton.set_property("height_request", 75)
        startButton.connect("clicked", self.advance)
        logoBox.pack_start(startButton, True, True, 50)
        pageContainerBox.pack_start(logoBox, True, False, 10)
        pageBox.pack_start(pageContainerBox, True, False, 0)
        self.win.add(pageBox)
        self.page_element = pageBox

    def seventh_page(self):
        pageBox = Gtk.Box(orientation=Gtk.Orientation.HORIZONTAL, spacing=1)
        pageContainerBox = Gtk.Box(orientation=Gtk.Orientation.VERTICAL, spacing=1)
        logoBox = Gtk.Box(orientation=Gtk.Orientation.VERTICAL, spacing=0)
        logoBox.hexpand = False
        welcomeLabel = Gtk.Label()
        welcomeLabel.set_markup('<span size="42000"><b>Linfinity recommends</b></span>')
        logoBox.pack_start(welcomeLabel, True, True, 5)
        appLogo = Gtk.Image.new_from_pixbuf(GdkPixbuf.Pixbuf.new_from_file_at_scale("libreoffice.png", 250, 250, False))
        logoBox.pack_start(appLogo, True, True, 50)
        labelNext = Gtk.Label()
        labelNext.set_markup('<span size="16000">Edit and view your spreadsheets, Word documents or create presentations \nusing the powerful office suite, LibreOffice, which is installed out of the box!</span>')
        logoBox.pack_start(labelNext, True, True, 10)
        startButton = Gtk.Button(label="Next")
        for child in startButton.get_children():
            child.set_label('<span size="16000">NEXT</span>')
            child.set_use_markup(True)
        startButton.set_property("height_request", 75)
        startButton.connect("clicked", self.advance)
        logoBox.pack_start(startButton, True, True, 50)
        pageContainerBox.pack_start(logoBox, True, False, 10)
        pageBox.pack_start(pageContainerBox, True, False, 0)
        self.win.add(pageBox)
        self.page_element = pageBox

    def eighth_page(self):
        pageBox = Gtk.Box(orientation=Gtk.Orientation.HORIZONTAL, spacing=1)
        pageContainerBox = Gtk.Box(orientation=Gtk.Orientation.VERTICAL, spacing=1)
        logoBox = Gtk.Box(orientation=Gtk.Orientation.VERTICAL, spacing=0)
        logoBox.hexpand = False
        welcomeLabel = Gtk.Label()
        welcomeLabel.set_markup('<span size="42000"><b>Get apps</b></span>')
        logoBox.pack_start(welcomeLabel, True, True, 5)
        appLogo = Gtk.Image.new_from_pixbuf(GdkPixbuf.Pixbuf.new_from_file_at_scale("software.png", 250, 250, False))
        logoBox.pack_start(appLogo, True, True, 50)
        labelNext = Gtk.Label()
        labelNext.set_markup('<span size="16000">Install your favourite programs using the Software app.</span>')
        logoBox.pack_start(labelNext, True, True, 10)
        softwareButton = Gtk.Button(label="Software")
        for child in softwareButton.get_children():
            child.set_label('<span size="16000">Open Software</span>')
            child.set_use_markup(True)
        softwareButton.set_property("height_request", 75)
        softwareButton.connect("clicked", self.software)
        logoBox.pack_start(softwareButton, True, True, 5)
        startButton = Gtk.Button(label="Next")
        for child in startButton.get_children():
            child.set_label('<span size="16000">Next</span>')
            child.set_use_markup(True)
        startButton.set_property("height_request", 75)
        startButton.connect("clicked", self.advance)
        logoBox.pack_start(startButton, True, True, 5)
        pageContainerBox.pack_start(logoBox, True, False, 10)
        pageBox.pack_start(pageContainerBox, True, False, 0)
        self.win.add(pageBox)
        self.page_element = pageBox
    
    def eighth_page(self):
        pageBox = Gtk.Box(orientation=Gtk.Orientation.HORIZONTAL, spacing=1)
        pageContainerBox = Gtk.Box(orientation=Gtk.Orientation.VERTICAL, spacing=1)
        logoBox = Gtk.Box(orientation=Gtk.Orientation.VERTICAL, spacing=0)
        logoBox.hexpand = False
        anim = GdkPixbuf.PixbufAnimation.new_from_file("apps.gif")
        appLogo = Gtk.Image()
        appLogo.set_from_animation(anim)
        logoBox.pack_start(appLogo, True, True, 50)
        labelNext = Gtk.Label()
        labelNext.set_markup('<span size="12000">Alternatively, you can download apps from the Internet and install them. Linux software can \ntypically be downloaded in two formats: DEB and RPM. Linfinity Linux supports both, but DEB is preferred.\nOn the download page, there is usually an option to download either one. \nTo install a downloaded package, just drag-and-drop it into the Applications folder.</span>')
        logoBox.pack_start(labelNext, True, True, 10)
        startButton = Gtk.Button(label="Next")
        for child in startButton.get_children():
            child.set_label('<span size="16000">NEXT</span>')
            child.set_use_markup(True)
        startButton.set_property("height_request", 75)
        startButton.connect("clicked", self.advance)
        logoBox.pack_start(startButton, True, True, 50)
        pageContainerBox.pack_start(logoBox, True, False, 10)
        pageBox.pack_start(pageContainerBox, True, False, 0)
        self.win.add(pageBox)
        self.page_element = pageBox
    
    def ninth_page(self):
        pageBox = Gtk.Box(orientation=Gtk.Orientation.HORIZONTAL, spacing=1)
        pageContainerBox = Gtk.Box(
            orientation=Gtk.Orientation.VERTICAL, spacing=1)
        logoBox = Gtk.Box(orientation=Gtk.Orientation.VERTICAL, spacing=0)
        logoBox.hexpand = False
        logo = Gtk.Image.new_from_pixbuf(GdkPixbuf.Pixbuf.new_from_file_at_scale("logo.png", 200, 200, False))
        logoBox.pack_start(logo, True, True, 10)
        welcomeLabel = Gtk.Label()
        welcomeLabel.set_markup('<span size="42000"><b>This might take a few moments.</b></span>')
        logoBox.pack_start(welcomeLabel, True, True, 5)
        labelNext = Gtk.Label()
        labelNext.set_markup('<span size="18000">Don\'t turn off your PC</span>')
        logoBox.pack_start(labelNext, True, True, 20)
        spin = Gtk.Spinner()
        spin.set_size_request(100, 100)
        spin.start()
        logoBox.pack_start(spin, True, True, 20)
        pageContainerBox.pack_start(logoBox, True, False, 10)
        pageBox.pack_start(pageContainerBox, True, False, 0)
        self.win.add(pageBox)
        self.win.show_all()
        self.page_element = pageBox
        Popen(["/bin/bash", "/setup/postinst.sh"])

    def advance(self, widget):
        self.win.remove(self.page_element)
        self.page_index += 1
        self.pages[self.page_index]()
        self.win.show_all()

    def disadvance(self, widget):
        self.win.remove(self.page_element)
        self.page_index -= 1
        self.pages[self.page_index]()
        self.win.show_all()

    def wifi_settings(self, widget):
        os.system("gnome-control-center wifi")

    def eth_settings(self, widget):
        os.system("gnome-control-center network")
    
    def datetime(self, widget):
        os.system("gnome-control-center datetime")
    
    def region(self, widget):
        os.system("gnome-control-center region")
    
    def software(self, widget):
        os.system("gnome-software")

    def passwd(self, widget):
        pw = self.passwordEntry.get_text()
        cpw = self.cPasswordEntry.get_text()
        un = self.usernameEntry.get_text()
        if not pw == cpw:
            dialog = Gtk.MessageDialog(self.win, 0, Gtk.MessageType.INFO, Gtk.ButtonsType.OK, "The passwords do not match.")
            dialog.run()
            self.passwordEntry.set_text("")
            self.cPasswordEntry.set_text("")
            dialog.destroy()
        elif un == "":
            dialog = Gtk.MessageDialog(self.win, 0, Gtk.MessageType.INFO, Gtk.ButtonsType.OK, "Please enter a username.")
            dialog.run()
            dialog.destroy()
        else:
            cmd = 'useradd -m -d /home/' + un + ' -s /bin/bash -p $(echo ' + pw + ' | openssl passwd -1 -stdin) ' + un;
            os.system(cmd)
            self.advance(widget)


oobe = OOBE()
