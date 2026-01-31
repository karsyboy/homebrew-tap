class ColorSsh < Formula
  desc "A Rust-based SSH client with syntax highlighting."
  homepage "https://github.com/karsyboy/color-ssh"
  version "0.5.4"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/karsyboy/color-ssh/releases/download/v0.5.4/color-ssh-aarch64-apple-darwin.tar.xz"
      sha256 "480af7c1856e68f3f8d8be7d8155dff03acf0ef8e49b7302d1453979fbea89cd"
    end
    if Hardware::CPU.intel?
      url "https://github.com/karsyboy/color-ssh/releases/download/v0.5.4/color-ssh-x86_64-apple-darwin.tar.xz"
      sha256 "a644a2debf50b34572956542f81b35a9392b4b7cf680e94a8a107c73941b2883"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/karsyboy/color-ssh/releases/download/v0.5.4/color-ssh-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "49c7213df3d672722b81879d937c37e7b76091cb1097b4f7b09763d2d17e3c0c"
    end
    if Hardware::CPU.intel?
      url "https://github.com/karsyboy/color-ssh/releases/download/v0.5.4/color-ssh-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "ae5a29d41b260450494d01816403e312d1b61507827851374eb20e0a0ca5817d"
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
    bin.install "colorsh" if OS.mac? && Hardware::CPU.arm?
    bin.install "colorsh" if OS.mac? && Hardware::CPU.intel?
    bin.install "colorsh" if OS.linux? && Hardware::CPU.arm?
    bin.install "colorsh" if OS.linux? && Hardware::CPU.intel?

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
