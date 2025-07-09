from fpdf import FPDF
from fpdf.enums import XPos, YPos
import os

class ArabicPDF(FPDF):
    def __init__(self):
        super().__init__()
        self.set_margins(20, 20, 20)
        
        # Try these common Arabic-supporting fonts in order
        self.arabic_font = None
        for font in ["Arial Unicode MS", "DejaVuSans", "Amiri", "Times New Roman"]:
            try:
                if font == "Amiri":
                    # You'll need to download Amiri.ttf and place it in your folder
                    if os.path.exists("Amiri-Regular.ttf"):
                        self.add_font("Amiri", "", "Amiri-Regular.ttf", uni=True)
                        self.add_font("Amiri", "B", "Amiri-Bold.ttf", uni=True)
                        self.arabic_font = "Amiri"
                        break
                else:
                    # Try system fonts
                    self.set_font(font, "", 12)
                    self.arabic_font = font
                    break
            except:
                continue
    
    def header(self):
        if not self.arabic_font:
            raise ValueError("No suitable Arabic font found")
            
        self.set_font(self.arabic_font, "B", 16)
        self.cell(0, 10, "دراسة مشروع تطبيق تتبع المندوبين", align="C", new_x=XPos.LMARGIN, new_y=YPos.NEXT)
        self.ln(10)
    
    def section(self, title, content):
        self.set_font(self.arabic_font, "B", 14)
        self.cell(0, 10, title, align="R", new_x=XPos.LMARGIN, new_y=YPos.NEXT)
        self.set_font(self.arabic_font, "", 12)
        self.multi_cell(0, 10, content, align="R")
        self.ln(5)

# Create PDF
pdf = ArabicPDF()
pdf.add_page()

content_sections = [
    ("التقنيات المستخدمة",
     "- Flutter لتطبيق المندوب.\n"
     "- Firebase Realtime Database أو Firestore.\n"
     "- مكتبة Geolocator أو flutter_background_geolocation.\n"
     "- Firebase ML Kit للتعرف على النص (OCR).\n"
     "- Laravel + Vue أو Flutter Web للوحة التحكم.\n"
     "- Firebase Auth و FCM."),
    
    ("هيكلية الصلاحيات",
     "المدير العام > مسؤول المناطق > مسؤول منطقة > مندوب"),
    
    ("مميزات تطبيق المندوب",
     "- تسجيل دخول.\n"
     "- إرسال الموقع كل 3 - 5 ثواني في الخلفية.\n"
     "- تنبيه عند الخروج من المنطقة المحددة.\n"
     "- رفع صورة وتحويلها إلى نص.")
]

for title, body in content_sections:
    pdf.section(title, body)

pdf.output("arabic_report.pdf")
print("PDF generated successfully!")