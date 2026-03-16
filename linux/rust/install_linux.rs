use std::fs;
use std::io;
use std::path::Path;
use std::process::{Command, Stdio};

fn main() -> io::Result<()> {
    let url = "https://github.com/rustdesk/rustdesk/releases/download/nightly/rustdesk-1.4.6-x86_64.AppImage";
    let file = "/tmp/rustdesk.AppImage";
    let install_dir = "/opt/rustdesk";
    let config_dir = format!("{}/.config/rustdesk", std::env::var("HOME").unwrap());
    let desktop_file = "/usr/share/applications/fundesk.desktop";

    println!("RustDesk уже установлен? (y/n):");
    let mut answer = String::new();
    std::io::stdin().read_line(&mut answer)?;
    if !matches!(answer.trim().to_lowercase().as_str(), "y" | "yes") {
        Command::new("curl").args(["-L", url, "-o", file, "--progress-bar"]).status()?;
        Command::new("sudo").args(["rm", "-rf", install_dir]).status()?;
        Command::new("sudo").args(["mkdir", "-p", install_dir]).status()?;
        Command::new("sudo").args(["mv", file, &format!("{}/rustdesk.AppImage", install_dir)]).status()?;
        Command::new("sudo").args(["chmod", "+x", &format!("{}/rustdesk.AppImage", install_dir)]).status()?;
        Command::new("sudo").args(["ln", "-sf", &format!("{}/rustdesk.AppImage", install_dir), "/usr/local/bin/rustdesk"]).status()?;
    }

    fs::create_dir_all(&config_dir)?;
    fs::write(format!("{}/RustDesk2.toml", config_dir), r#"rendezvous_server = 'rust.funtime.network:21116'
nat_type = 1
serial = 0
unlock_pin = ''
trusted_devices = ''

[options]
key = 'XqVr4NcaZHovdbVITxcxexuqfLGv9IkNopevLCJhXHc='
temporary-password-length = '10'
local-ip-addr = '10.0.0.2'
custom-rendezvous-server = 'rust.funtime.network'
av1-test = 'Y'
relay-server = 'rust.funtime.network'
api-server = 'https://rust.funtime.network'
allow-remote-config-modification = 'Y'
"#)?;

    let desktop_content = format!(r#"[Desktop Entry]
Version=1.0
Type=Application
Name=RustDesk
Exec={}/rustdesk.AppImage
Icon={}/rustdesk.AppImage
Terminal=false
Categories=Network;Utility;
"#, install_dir, install_dir);

    let file_desktop = "/tmp/fundesk.desktop";
    fs::write(file_desktop, desktop_content)?;
    let _ = Command::new("sudo").args(["mv", file_desktop, desktop_file]).status()?;
    
    if Path::new("/usr/local/bin/rustdesk").exists() {
        Command::new("/usr/local/bin/rustdesk").stdout(Stdio::null()).stderr(Stdio::null()).stdin(Stdio::null()).spawn()?;
        println!("RustDesk запущен.");
    }

    println!("Готово.");
    Ok(())
}
