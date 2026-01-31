class ColorSsh < Formula
  desc "A Rust-based SSH client with syntax highlighting."
  homepage "https://github.com/karsyboy/color-ssh"
  version "0.5.3"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/karsyboy/color-ssh/releases/download/v0.5.3/color-ssh-aarch64-apple-darwin.tar.xz"
      sha256 "17612087b1818b34a5aafb228a574c7aa8aa2797c1134d2d2f70b16e1c728084"
    end
    if Hardware::CPU.intel?
      url "https://github.com/karsyboy/color-ssh/releases/download/v0.5.3/color-ssh-x86_64-apple-darwin.tar.xz"
      sha256 "22a79df672bde2c0b5ca38f07234d5b6575e325f91aba1def90458927a82f165"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/karsyboy/color-ssh/releases/download/v0.5.3/color-ssh-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "d005b4754743cf35e9a0e9ba7e8bf91e39ece7e2874beb0be801c3679ee1642c"
    end
    if Hardware::CPU.intel?
      url "https://github.com/karsyboy/color-ssh/releases/download/v0.5.3/color-ssh-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "4e8984f31e43ad3c41a253808550ab32616970cd7cc8a217a25d7c92c0d5c169"
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
