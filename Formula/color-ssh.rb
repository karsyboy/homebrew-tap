class ColorSsh < Formula
  desc "A Rust-based SSH client with syntax highlighting."
  homepage "https://github.com/karsyboy/color-ssh"
  version "0.6.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/karsyboy/color-ssh/releases/download/v0.6.0/color-ssh-aarch64-apple-darwin.tar.xz"
      sha256 "20465359366a0f2d4d41ad286b98d5412c79dc11c97c24db859b8ef6b7285721"
    end
    if Hardware::CPU.intel?
      url "https://github.com/karsyboy/color-ssh/releases/download/v0.6.0/color-ssh-x86_64-apple-darwin.tar.xz"
      sha256 "d2549f276b22a906a05aa5e9aeb88fbc057777ff8ee49be6eee213730f8e0727"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/karsyboy/color-ssh/releases/download/v0.6.0/color-ssh-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "f29721bc74f41b43e471e2c832bc2aaac5142d0bb4b2008bbb96ef5979663220"
    end
    if Hardware::CPU.intel?
      url "https://github.com/karsyboy/color-ssh/releases/download/v0.6.0/color-ssh-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "ac736a759340be32ecebf4e0b7744cc59293108a948410bfd8322e97b9878f0a"
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
