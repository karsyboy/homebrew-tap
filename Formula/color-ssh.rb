class ColorSsh < Formula
  desc "A Rust-based SSH client with syntax highlighting."
  homepage "https://github.com/karsyboy/color-ssh"
  version "0.5.6"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/karsyboy/color-ssh/releases/download/v0.5.6/color-ssh-aarch64-apple-darwin.tar.xz"
      sha256 "f6df290acdf17cea82e1802f4f958757e8bf86673e66a6c1685dbb75f3901f2a"
    end
    if Hardware::CPU.intel?
      url "https://github.com/karsyboy/color-ssh/releases/download/v0.5.6/color-ssh-x86_64-apple-darwin.tar.xz"
      sha256 "407568dd7717bc1b1f5f03e9dcb8129807e1b65a119de1fc3d4181fc5b3a7c15"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/karsyboy/color-ssh/releases/download/v0.5.6/color-ssh-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "0ad14ef510860c4e99339449a89a5a92a358a82efb11d20bcc8ff0169cefee7f"
    end
    if Hardware::CPU.intel?
      url "https://github.com/karsyboy/color-ssh/releases/download/v0.5.6/color-ssh-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "19866d198a296203e1a9252959624c0d41f3848b10c931eeabafa18334474264"
    end
  end
  license "MIT"

  BINARY_ALIASES = {
    "aarch64-apple-darwin":              {},
    "aarch64-unknown-linux-gnu":         {},
    "x86_64-apple-darwin":               {},
    "x86_64-pc-windows-gnu":             {},
    "x86_64-unknown-linux-gnu":          {},
    "x86_64-unknown-linux-musl-dynamic": {},
    "x86_64-unknown-linux-musl-static":  {},
  }.freeze

  def target_triple
    cpu = Hardware::CPU.arm? ? "aarch64" : "x86_64"
    os = OS.mac? ? "apple-darwin" : "unknown-linux-gnu"

    "#{cpu}-#{os}"
  end

  def install_binary_aliases!
    BINARY_ALIASES[target_triple.to_sym].each do |source, dests|
      dests.each do |dest|
        bin.install_symlink bin/source.to_s => dest
      end
    end
  end

  def install
    bin.install "cossh" if OS.mac? && Hardware::CPU.arm?
    bin.install "cossh" if OS.mac? && Hardware::CPU.intel?
    bin.install "cossh" if OS.linux? && Hardware::CPU.arm?
    bin.install "cossh" if OS.linux? && Hardware::CPU.intel?

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
