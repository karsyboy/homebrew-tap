class ColorSsh < Formula
  desc "A Rust-based SSH client with syntax highlighting."
  homepage "https://github.com/karsyboy/color-ssh"
  version "0.8.2"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/karsyboy/color-ssh/releases/download/v0.8.2/color-ssh-aarch64-apple-darwin.tar.xz"
      sha256 "94633edbfb29a8fc0faaaadd92f825ac7ab7bad9cab92d602d70ab177274c421"
    end
    if Hardware::CPU.intel?
      url "https://github.com/karsyboy/color-ssh/releases/download/v0.8.2/color-ssh-x86_64-apple-darwin.tar.xz"
      sha256 "11989dca4c4f50b69767f5864869f64d45aee958a59ba952c1438add1f258a75"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/karsyboy/color-ssh/releases/download/v0.8.2/color-ssh-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "740f0c81af761aa48d99531f2e3e7f4dfa700ee8b378b8972a802c752d50bd1e"
    end
    if Hardware::CPU.intel?
      url "https://github.com/karsyboy/color-ssh/releases/download/v0.8.2/color-ssh-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "aac1ea0d755a3524e3e3c663ee8d575e103a2452c4a6d7e62d48a32dfb48e274"
    end
  end
  license "MIT"

  BINARY_ALIASES = {
    "aarch64-apple-darwin":              {},
    "aarch64-unknown-linux-gnu":         {},
    "x86_64-apple-darwin":               {},
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
