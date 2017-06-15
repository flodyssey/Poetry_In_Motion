package sound;
import java.text.Normalizer;

public class SpeechSynthesis {

    private final boolean mVerbose;
    private final boolean mRemoveSpecialChars;
    private boolean mBlocking = true;
    private int mWordsPerMinute = 0;
    private String mFileName = null;
    private String audioDevice = "";

    public String getAudioDevice() {
    return audioDevice;
  }

  public void setAudioDevice(String audioDevice) {
    this.audioDevice = audioDevice;
  }

  public SpeechSynthesis() {
        mVerbose = false;
        mRemoveSpecialChars = true;
    }

    public SpeechSynthesis(boolean verbose, boolean remove_special_characters) {
        mVerbose = verbose;
        mRemoveSpecialChars = remove_special_characters;
    }

    public Process say(String pVoice, String pMessage, boolean pBlocking, int pWordsPerMinute, String pFileName) {
        if (mVerbose) {
            System.out.println("### saying: " + pMessage);
        }
        try {
            if (mRemoveSpecialChars) {
                final String[] searchList = {"ƒ", "‰", "÷", "ˆ", "‹", "¸", "ﬂ"};
                final String[] replaceList = {"Ae", "ae", "Oe", "oe", "Ue", "ue", "sz"};
                for (int i = 0; i < replaceList.length; i++) {
                    pMessage = pMessage.replace(searchList[i], replaceList[i]);
                }
                pMessage = Normalizer.normalize(pMessage, Normalizer.Form.NFD).replaceAll("[^\\p{ASCII}]", "");
                pMessage = pMessage.replaceAll("/[^[:alnum:]]/", " ");
            }

            String[] mCommand = new String[]{"say",
                                             pVoice.isEmpty() ? "" : "-v",
                                             pVoice.isEmpty() ? "" : pVoice,
                                             audioDevice.isEmpty() ? "" : "-a",
                                             audioDevice.isEmpty() ? "" : audioDevice,
                                             pWordsPerMinute > 0 ? "-r" : "",
                                             pWordsPerMinute > 0 ? "" + pWordsPerMinute : "",
                                             (pFileName != null && !pFileName.isEmpty()) ? "-o" : "",
                                             (pFileName != null && !pFileName.isEmpty()) ? pFileName : "",
                                             "\"" + pMessage + "\""};
            if (mVerbose) {
                System.out.print("### ");
                for (String mCommandSeg : mCommand) {
                    System.out.print(mCommandSeg);
                    System.out.print(" ");
                }
                System.out.println("");
            }
            final Process p = Runtime.getRuntime().exec(mCommand);
            if (pBlocking) {
                int mExit = p.waitFor();
                if (mVerbose) {
                    System.out.println("### exit value: " + mExit);
                }
            }
            return p;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    public void blocking(boolean pMakeBlocking) {
        mBlocking = pMakeBlocking;
    }

    public void setWordsPerMinute(int pWordsPerMinute) {
        mWordsPerMinute = pWordsPerMinute;
    }

    public void setFileName(String fileName) {
        mFileName = fileName;
    }

    public Process say(String message) {
        return say("", message, mBlocking, mWordsPerMinute, mFileName);
    }

    public Process say(String voice, String message) {
        return say(voice, message, mBlocking, mWordsPerMinute, mFileName);
    }

    /*
     * use `man say` to get a full description of the say tool.
     *
     * examplary outout of `say -v ?`
     *     Alex                en_US    # Most people recognize me by my voice.
     *     Alice               it_IT    # Salve, mi chiamo Alice e sono una voce italiana.
     *     Alva                sv_SE    # Hej, jag heter Alva. Jag är en svensk röst.
     *     Amelie              fr_CA    # Bonjour, je m’appelle Amelie. Je suis une voix canadienne.
     *     Anna                de_DE    # Hallo, ich heiße Anna und ich bin eine deutsche Stimme.
     *     Carmit              he_IL    # שלום. קוראים לי כרמית, ואני קול בשפה העברית.
     *     Damayanti           id_ID    # Halo, nama saya Damayanti. Saya berbahasa Indonesia.
     *     Daniel              en_GB    # Hello, my name is Daniel. I am a British-English voice.
     *     Diego               es_AR    # Hola, me llamo Diego y soy una voz española.
     *     Ellen               nl_BE    # Hallo, mijn naam is Ellen. Ik ben een Belgische stem.
     *     Fiona               en-scotland # Hello, my name is Fiona. I am a Scottish-English voice.
     *     Fred                en_US    # I sure like being inside this fancy computer
     *     Ioana               ro_RO    # Bună, mă cheamă Ioana . Sunt o voce românească.
     *     Joana               pt_PT    # Olá, chamo-me Joana e dou voz ao português falado em Portugal.
     *     Jorge               es_ES    # Hola, me llamo Jorge y soy una voz española.
     *     Juan                es_MX    # Hola, me llamo Juan y soy una voz mexicana.
     *     Kanya               th_TH    # สวัสดีค่ะ ดิฉันชื่อKanya
     *     Karen               en_AU    # Hello, my name is Karen. I am an Australian-English voice.
     *     Kyoko               ja_JP    # こんにちは、私の名前はKyokoです。日本語の音声をお届けします。
     *     Laura               sk_SK    # Ahoj. Volám sa Laura . Som hlas v slovenskom jazyku.
     *     Lekha               hi_IN    # नमस्कार, मेरा नाम लेखा है.Lekha मै हिंदी मे बोलने वाली आवाज़ हूँ.
     *     Luca                it_IT    # Salve, mi chiamo Luca e sono una voce italiana.
     *     Luciana             pt_BR    # Olá, o meu nome é Luciana e a minha voz corresponde ao português que é falado no Brasil
     *     Maged               ar_SA    # مرحبًا اسمي Maged. أنا عربي من السعودية.
     *     Mariska             hu_HU    # Üdvözlöm! Mariska vagyok. Én vagyok a magyar hang.
     *     Mei-Jia             zh_TW    # 您好，我叫美佳。我說國語。
     *     Melina              el_GR    # Γεια σας, ονομάζομαι Melina. Είμαι μια ελληνική φωνή.
     *     Milena              ru_RU    # Здравствуйте, меня зовут Milena. Я – русский голос системы.
     *     Moira               en_IE    # Hello, my name is Moira. I am an Irish-English voice.
     *     Monica              es_ES    # Hola, me llamo Monica y soy una voz española.
     *     Nora                nb_NO    # Hei, jeg heter Nora. Jeg er en norsk stemme.
     *     Paulina             es_MX    # Hola, me llamo Paulina y soy una voz mexicana.
     *     Samantha            en_US    # Hello, my name is Samantha. I am an American-English voice.
     *     Sara                da_DK    # Hej, jeg hedder Sara. Jeg er en dansk stemme.
     *     Satu                fi_FI    # Hei, minun nimeni on Satu. Olen suomalainen ääni.
     *     Sin-ji              zh_HK    # 您好，我叫 Sin-ji。我講廣東話。
     *     Tessa               en_ZA    # Hello, my name is Tessa. I am a South African-English voice.
     *     Thomas              fr_FR    # Bonjour, je m’appelle Thomas. Je suis une voix française.
     *     Ting-Ting           zh_CN    # 您好，我叫Ting-Ting。我讲中文普通话。
     *     Veena               en_IN    # Hello, my name is Veena. I am an Indian-English voice.
     *     Victoria            en_US    # Isn't it nice to have a computer that will talk to you?
     *     Xander              nl_NL    # Hallo, mijn naam is Xander. Ik ben een Nederlandse stem.
     *     Yelda               tr_TR    # Merhaba, benim adım Yelda. Ben Türkçe bir sesim.
     *     Yuna                ko_KR    # 안녕하세요. 제 이름은 Yuna입니다. 저는 한국어 음성입니다.
     *     Yuri                ru_RU    # Здравствуйте, меня зовут Yuri. Я – русский голос системы.
     *     Zosia               pl_PL    # Witaj. Mam na imię Zosia, jestem głosem kobiecym dla języka polskiego.
     *     Zuzana              cs_CZ    # Dobrý den, jmenuji se Zuzana. Jsem český hlas.
     *
     */
}