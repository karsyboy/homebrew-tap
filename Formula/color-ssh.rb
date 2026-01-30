class ColorSsh < Formula
  desc "A Rust-based SSH client with syntax highlighting."
  homepage "https://github.com/karsyboy/color-ssh"
  version "0.5.2"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/karsyboy/color-ssh/releases/download/v0.5.2/color-ssh-aarch64-apple-darwin.tar.xz"
      sha256 "3bc7523154cad333beb2ce909031c4daa23af2d0df11de1d548852bcaf26671c"
    end
    if Hardware::CPU.intel?
      url "https://github.com/karsyboy/color-ssh/releases/download/v0.5.2/color-ssh-x86_64-apple-darwin.tar.xz"
      sha256 "251b888125763aab3ab4bee573e1876a689fe6ac6b5a77fbb5ef99a8770051f5"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/karsyboy/color-ssh/releases/download/v0.5.2/color-ssh-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "f54d57be4cec0a8a89ec0d0a53149928d91d6dc3420fe9f3fab81306b46260e5"
    end
    if Hardware::CPU.intel?
      url "https://github.com/karsyboy/color-ssh/releases/download/v0.5.2/color-ssh-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "1c4cb3678dd455d7613a3e22e4f216f416db8cbcf1a522bca693f0a78e86ed0f"
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
    bin.install "csh" if OS.mac? && Hardware::CPU.arm?
    bin.install "csh" if OS.mac? && Hardware::CPU.intel?
    bin.install "csh" if OS.linux? && Hardware::CPU.arm?
    bin.install "csh" if OS.linux? && Hardware::CPU.intel?

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
